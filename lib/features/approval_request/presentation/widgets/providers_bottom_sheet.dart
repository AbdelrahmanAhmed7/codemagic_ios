import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/provider_list_item.dart';
import 'package:mediconsult/features/providers/presentation/cubit/providers_cubit.dart';
import 'package:mediconsult/features/providers/presentation/cubit/providers_state.dart';

/// Bottom sheet for selecting providers with search and pagination
class ProvidersBottomSheet extends StatefulWidget {
  const ProvidersBottomSheet({super.key});

  @override
  State<ProvidersBottomSheet> createState() => _ProvidersBottomSheetState();
}

class _ProvidersBottomSheetState extends State<ProvidersBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  int _page = 1;
  int _pageSize = 20;
  String? _search;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _isDisposed = true;
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _isDisposed) return;

    // Dismiss keyboard once user starts scrolling
    FocusScope.of(context).unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    final position = _scrollController.position;
    final maxExtent = position.maxScrollExtent;
    final currentOffset = position.pixels;

    // Load more when 80% scrolled
    if (currentOffset >= maxExtent * 0.8) {
      final state = context.read<ProvidersCubit>().state;
      if (state is Loaded &&
          state.pagination.hasNextPage &&
          !state.isLoadingMore) {
        _page = state.pagination.currentPage + 1;
        if (!_isDisposed) {
          context.read<ProvidersCubit>().loadProviders(
            lang: context.locale.languageCode,
            page: _page,
            pageSize: _pageSize,
            search: _search,
          );
        }
      }
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    // Clear search immediately if empty
    if (value.isEmpty) {
      _search = null;
      _page = 1;
      context.read<ProvidersCubit>().loadProviders(
        lang: context.locale.languageCode,
        page: _page,
        pageSize: _pageSize,
        search: _search,
      );
      return;
    }

    // Debounce search with shorter delay for better UX
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!_isDisposed && value.trim().length >= 2) {
        _search = value.trim();
        _page = 1;
        context.read<ProvidersCubit>().loadProviders(
          lang: context.locale.languageCode,
          page: _page,
          pageSize: _pageSize,
          search: _search,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteClr,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            top: 16.w,
            bottom: bottomInset > 0 ? bottomInset : 16.w,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.lightGreyClr,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Text(
                'approval_request.select_provider'.tr(),
                style: AppTextStyles.font16BlackMedium(context),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'approval_request.search_providers_min_2_chars'
                      .tr(),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Flexible(
                child: BlocBuilder<ProvidersCubit, ProvidersState>(
                  builder: (context, state) {
                    if (state is Loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is Failed) {
                      return Center(
                        child: Text(
                          state.message,
                          style: AppTextStyles.font14GreyRegular(context),
                        ),
                      );
                    }
                    final loaded = state as Loaded;
                    final items = loaded.providers;
                    return ListView.separated(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount:
                          items.length +
                          (loaded.pagination.hasNextPage ? 1 : 0),
                      separatorBuilder: (_, __) => const Divider(
                        color: AppColors.lightGreyClr,
                        height: 1,
                        thickness: 0.5,
                      ),
                      cacheExtent: 500,
                      addAutomaticKeepAlives: true,
                      addRepaintBoundaries: true,
                      addSemanticIndexes: false,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (index >= items.length) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          );
                        }
                        final item = items[index];
                        return ProviderListItem(
                          key: ValueKey(item.id),
                          item: item,
                          onTap: () => Navigator.of(context).pop(item),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
