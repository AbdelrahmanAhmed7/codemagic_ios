import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/providers/data/providers_models.dart';
import 'package:mediconsult/features/providers/presentation/cubit/providers_cubit.dart';
import 'package:mediconsult/features/providers/presentation/cubit/providers_state.dart';
import 'package:mediconsult/core/di/service_locator.dart';
import 'package:mediconsult/features/providers/repository/providers_repository.dart';

class ProviderSelector extends StatefulWidget {
  const ProviderSelector({super.key});

  @override
  State<ProviderSelector> createState() => _ProviderSelectorState();
}

class _ProviderSelectorState extends State<ProviderSelector> {
  ProviderItem? _selectedProvider;
  bool _chronic = false;

  @override
  Widget build(BuildContext context) {
    final isElezaby = (_selectedProvider?.name ?? '').toLowerCase().contains('ezaby') ||
        (_selectedProvider?.name ?? '').toLowerCase().contains('elezaby');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(12.r,),
          onTap: _openProvidersSheet,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: AppColors.whiteClr,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Color(0xffECECEC)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.greyClr.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_selectedProvider != null)
                  Container(
                    width: 28.w,
                    height: 28.w,
                    margin: EdgeInsets.only(right: 8.w),
                    decoration: BoxDecoration(
                      color: AppColors.lightGreyClr,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      _assetForProvider(_selectedProvider!.name),
                      fit: BoxFit.cover,
                    ),
                  ),
                Expanded(
                  child: Text(
                    _selectedProvider?.name ?? 'Select provider',
                    style: _selectedProvider == null
                        ? AppTextStyles.font14GreyRegular
                        : AppTextStyles.font14BlackMedium,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: AppColors.greyClr),
              ],
            ),
          ),
        ),
        if (isElezaby) ...[
          SizedBox(height: 8.h),
          Row(
            children: [
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: _chronic,
                  activeThumbColor: AppColors.primaryClr,
                  onChanged: (v) => setState(() => _chronic = v),
                ),
              ),
              // SizedBox(width: 8.w),
              Text('Chronic Treatment', style: AppTextStyles.font14BlackMedium),
            ],
          ),
        ],
      ],
    );
  }

  void _openProvidersSheet() async {
    final result = await showModalBottomSheet<ProviderItem>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        // Use app-wide DI to ensure authorized Dio
        return BlocProvider(
          create: (_) => sl<ProvidersCubit>()..loadProviders(lang: 'en', page: 1, pageSize: 10),
          child: _ProvidersBottomSheet(),
        );
      },
    );

    if (!mounted) return;
    if (result != null) {
      setState(() {
        _selectedProvider = result;
        if (!((_selectedProvider?.name ?? '').toLowerCase().contains('ezaby') ||
            (_selectedProvider?.name ?? '').toLowerCase().contains('elezaby'))) {
          _chronic = false;
        }
      });
    }
  }

  String _assetForProvider(String name) {
    final normalized = name.toLowerCase();
    if (normalized.contains('shifa')) return AppAssets.shifa;
    if (normalized.contains('ezaby') || normalized.contains('elezaby')) {
      return AppAssets.elezaby;
    }
    if (normalized.contains('alfa')) return AppAssets.alfaLogo;
    if (normalized.contains('scan')) return AppAssets.misrScan;
    return AppAssets.providers;
  }
}

class _ProvidersBottomSheet extends StatefulWidget {
  @override
  State<_ProvidersBottomSheet> createState() => _ProvidersBottomSheetState();
}

class _ProvidersBottomSheetState extends State<_ProvidersBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  int _page = 1;
  int _pageSize = 20; // Increased page size for better performance
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
                lang: 'en',
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
            lang: 'en',
            page: _page,
            pageSize: _pageSize,
            search: _search,
          );
      return;
    }
    
    // Debounce search with shorter delay for better UX
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!_isDisposed && value.trim().length >= 2) { // Minimum 2 characters
        _search = value.trim();
        _page = 1;
        context.read<ProvidersCubit>().loadProviders(
              lang: 'en',
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
              Text('Select provider', style: AppTextStyles.font16BlackMedium),
              SizedBox(height: 12.h),
              TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Search providers (min 2 chars)',
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
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
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
                        child: Text(state.message, style: AppTextStyles.font14GreyRegular),
                      );
                    }
                    final loaded = state as Loaded;
                    final items = loaded.providers;
                    return ListView.separated(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: items.length + (loaded.pagination.hasNextPage ? 1 : 0),
                      separatorBuilder: (_, __) => const Divider(
                        color: AppColors.lightGreyClr,
                        height: 1,
                        thickness: 0.5,
                      ),
                      // Performance optimizations
                      cacheExtent: 500, // Increased cache for smoother scrolling
                      addAutomaticKeepAlives: true,
                      addRepaintBoundaries: true,
                      addSemanticIndexes: false,
                      // Physics optimizations
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (index >= items.length) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          );
                        }
                        final item = items[index];
                        return _ProviderListItem(
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

  String _assetFor(String name) => _ProviderSelectorState()._assetForProvider(name);
}

class _ProviderListItem extends StatefulWidget {
  final ProviderItem item;
  final VoidCallback onTap;

  const _ProviderListItem({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  State<_ProviderListItem> createState() => _ProviderListItemState();
}

class _ProviderListItemState extends State<_ProviderListItem>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RepaintBoundary(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.lightGreyClr,
          foregroundImage: AssetImage(
            _assetForProvider(widget.item.name),
          ),
        ),
        title: Text(
          widget.item.name,
          style: AppTextStyles.font14BlackMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          widget.item.categoryName ?? '',
          style: AppTextStyles.font12GreyRegular,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: widget.onTap,
        // Performance optimizations
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      ),
    );
  }

  String _assetForProvider(String name) {
    final normalized = name.toLowerCase();
    if (normalized.contains('shifa')) return AppAssets.shifa;
    if (normalized.contains('ezaby') || normalized.contains('elezaby')) {
      return AppAssets.elezaby;
    }
    if (normalized.contains('alfa')) return AppAssets.alfaLogo;
    if (normalized.contains('scan')) return AppAssets.misrScan;
    return AppAssets.providers;
  }
}
