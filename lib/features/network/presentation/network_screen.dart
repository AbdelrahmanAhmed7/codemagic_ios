import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/error/app_error_handler.dart';
import 'package:mediconsult/features/network/logic/network_cubit.dart';
import 'package:mediconsult/features/network/logic/network_state.dart';
import 'package:mediconsult/features/network/presentation/widgets/empty_providers_state.dart';
import 'package:mediconsult/features/network/presentation/widgets/network_categories_list.dart';
import 'package:mediconsult/features/network/presentation/widgets/network_filter_bottom_sheet.dart';
import 'package:mediconsult/features/network/presentation/widgets/provider_card.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({super.key});

  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _hasLoadedInitialData = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    // Request location and load providers after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocation();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasLoadedInitialData) {
      final cubit = context.read<NetworkCubit>();
      cubit.getCategories(context: context);
      cubit.getGovernments(context: context);
      _hasLoadedInitialData = true;
    }
  }

  Future<void> _initializeLocation() async {
    final cubit = context.read<NetworkCubit>();

    // Try to get user location (will show permission dialog)
    await cubit.getUserLocation();

    // If location retrieved successfully, load providers
    if (cubit.userLatitude != null && cubit.userLongitude != null) {
      await cubit.searchProviders(resetPage: true, context: context);
    } else {
      // fallback: load random providers or show message
      await cubit.searchProviders(resetPage: true, context: context);
    }
  }

  void _onScroll() async {
    if (_isLoadingMore) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      _isLoadingMore = true;
      try {
        await context.read<NetworkCubit>().loadMoreProviders(context: context);
      } finally {
        _isLoadingMore = false;
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showFilterBottomSheet() {
    final cubit = context.read<NetworkCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => BlocProvider.value(
        value: cubit,
        child: const NetworkFilterBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreyClr,
      body: BlocListener<NetworkCubit, NetworkState>(
        listener: (context, state) {
          if (state is ProvidersError) {
            AppErrorHandler.showErrorSnackBar(
              context,
              state.error,
              onRetry: () {
                context.read<NetworkCubit>().searchProviders(resetPage: true);
              },
            );
          }
          if (state is CategoriesError) {
            AppErrorHandler.showErrorSnackBar(
              context,
              state.error,
              onRetry: () {
                context.read<NetworkCubit>().getCategories();
              },
            );
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              PageHeader(title: 'network.title'.tr(), backPath: '/home'),
              SizedBox(height: 16.h),

              Expanded(
                child: Transform.translate(
                  offset: Offset(0, -28.h),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.whiteClr,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.greyClr.withValues(alpha: 0.08),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Categories Section
                              BlocBuilder<NetworkCubit, NetworkState>(
                                buildWhen: (previous, current) =>
                                    current is CategoriesLoading ||
                                    current is CategoriesSuccess ||
                                    current is CategoriesError,
                                builder: (context, state) {
                                  if (state is CategoriesLoading) {
                                    return SizedBox(
                                      height: 100.h,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }

                                  final categories = context
                                      .read<NetworkCubit>()
                                      .categories;

                                  if (categories.isEmpty) {
                                    return const SizedBox.shrink();
                                  }

                                  return NetworkCategoriesList(
                                    categories: categories,
                                    selectedCategoryId: context
                                        .read<NetworkCubit>()
                                        .selectedCategoryId,
                                    onCategorySelected: (categoryId) {
                                      context
                                          .read<NetworkCubit>()
                                          .searchProviders(
                                            categoryId: categoryId,
                                            resetPage: true,
                                          );
                                    },
                                  );
                                },
                              ),

                              SizedBox(height: 16.h),

                              // Search and Filter Bar
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      decoration: InputDecoration(
                                        hintText: 'network.search_placeholder'
                                            .tr(),
                                        hintStyle:
                                            AppTextStyles.font14GreyRegular(
                                              context,
                                            ),
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: AppColors.greyClr,
                                          size: 20.sp,
                                        ),
                                        filled: true,
                                        fillColor: AppColors.lightGreyClr,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                          vertical: 12.h,
                                        ),
                                      ),
                                      onSubmitted: (value) async {
                                        final cubit = context
                                            .read<NetworkCubit>();

                                        // Ensure we have user location before searching
                                        if (cubit.userLatitude == null ||
                                            cubit.userLongitude == null) {
                                          await cubit.getUserLocation();
                                        }

                                        cubit.searchProviders(
                                          searchKey: value.isNotEmpty
                                              ? value
                                              : null,
                                          resetPage: true,
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  GestureDetector(
                                    onTap: _showFilterBottomSheet,
                                    child: Container(
                                      padding: EdgeInsets.all(12.w),
                                      decoration: BoxDecoration(
                                        color:
                                            context
                                                .watch<NetworkCubit>()
                                                .hasActiveFilters
                                            ? AppColors.primaryClr
                                            : AppColors.lightGreyClr,
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.tune,
                                        color:
                                            context
                                                .watch<NetworkCubit>()
                                                .hasActiveFilters
                                            ? AppColors.whiteClr
                                            : AppColors.greyClr,
                                        size: 20.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 16.h),

                              // Providers List
                              SizedBox(height: 500.h, child: _buildListView()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return BlocBuilder<NetworkCubit, NetworkState>(
      buildWhen: (previous, current) =>
          current is ProvidersLoading ||
          current is ProvidersSuccess ||
          current is ProvidersError ||
          current is ProvidersEmpty ||
          current is ProvidersLoadingMore,
      builder: (context, state) {
        final cubit = context.read<NetworkCubit>();
        final providers = cubit.currentProviders;
        final hasNextPage =
            cubit.currentProviderData?.pagination.hasNextPage ?? false;

        // Show loading only when actively searching (first load)
        if (state is ProvidersLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show empty state (initial state or no results)
        if (providers.isEmpty) {
          return const EmptyProvidersState();
        }

        // Show list of providers with pagination indicator
        return ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 16.h, bottom: 24.h),
          itemCount: providers.length + (hasNextPage ? 1 : 0),
          itemBuilder: (context, index) {
            // Show provider card
            if (index < providers.length) {
              return ProviderCard(provider: providers[index]);
            }

            // Show loading indicator at the end
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(child: CircularProgressIndicator()),
            );
          },
        );
      },
    );
  }
}
