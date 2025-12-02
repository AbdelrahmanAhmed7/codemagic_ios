import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/error/app_error_handler.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/features/network/logic/network_cubit.dart';
import 'package:mediconsult/features/network/logic/network_state.dart';
import 'package:mediconsult/features/network/presentation/widgets/network_categories_list.dart';
import 'package:mediconsult/features/network/presentation/widgets/network_filter_bottom_sheet.dart';
import 'package:mediconsult/features/network/presentation/widgets/network_providers_list.dart';
import 'package:mediconsult/features/network/presentation/widgets/network_search_bar.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:showcaseview/showcaseview.dart';
// ignore_for_file: deprecated_member_use

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
  String? _previousSearchText;

  // Showcase keys
  final GlobalKey _categoriesKey = GlobalKey();
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _navigateKey = GlobalKey();
  final GlobalKey _phoneKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    // Request location and load providers after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocation();
      // إضافة listener على حقل البحث بعد بناء الـ widget
      _setupSearchListener();
    });
  }

  void _setupSearchListener() {
    _searchController.addListener(() {
      final currentText = _searchController.text;

      // لو النص اتغير من filled لـ empty، نرجع للقائمة الأصلية
      if (currentText.isEmpty &&
          _previousSearchText != null &&
          _previousSearchText!.isNotEmpty &&
          mounted) {
        final cubit = context.read<NetworkCubit>();
        // البحث بدون searchKey يرجع للقائمة الأصلية
        cubit.searchProviders(
          searchKey: null,
          categoryId: cubit.selectedCategoryId,
          governmentId: cubit.selectedGovernmentId,
          cityId: cubit.selectedCityId,
          resetPage: true,
          context: context,
        );
      }
      _previousSearchText = currentText;
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

    // Show location permission dialog
    await cubit.requestLocationWithDialog(context);
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
    return ShowCaseWidget(
      builder: (context) => Scaffold(
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
                PageHeader(
                  title: 'network.title'.tr(),
                  backPath: '/home',
                  onHelp: () {
                    ShowCaseWidget.of(context).startShowCase([
                      _categoriesKey,
                      _searchKey,
                      _navigateKey,
                      _phoneKey,
                    ]);
                  },
                ),
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
                                color: AppColors.greyClr.withValues(
                                  alpha: 0.08,
                                ),
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

                                    return Showcase(
                                      key: _categoriesKey,
                                      description: 'tutorial.network.categories'
                                          .tr()
                                          .tr(),
                                      child: BlocBuilder<NetworkCubit, NetworkState>(
                                        buildWhen: (previous, current) => true,
                                        builder: (context, state) {
                                          final cubit = context
                                              .read<NetworkCubit>();
                                          return NetworkCategoriesList(
                                            categories: categories,
                                            selectedCategoryId:
                                                cubit.selectedCategoryId,
                                            onCategorySelected: (categoryId) {
                                              // Preserve existing filters (government and city) when selecting category
                                              cubit.searchProviders(
                                                categoryId: categoryId,
                                                governmentId:
                                                    cubit.selectedGovernmentId,
                                                cityId: cubit.selectedCityId,
                                                resetPage: true,
                                                context: context,
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),

                                SizedBox(height: 16.h),

                                // Search and Filter Bar
                                Showcase(
                                  key: _searchKey,
                                  description: 'tutorial.network.search'.tr(),
                                  child: NetworkSearchBar(
                                    searchController: _searchController,
                                    onFilterTap: _showFilterBottomSheet,
                                    onSearchSubmitted: (value) async {
                                      final cubit = context
                                          .read<NetworkCubit>();

                                      // Try to get user location but don't block search if it fails
                                      if (cubit.userLatitude == null ||
                                          cubit.userLongitude == null) {
                                        try {
                                          await cubit.getUserLocation();
                                        } catch (e) {
                                          // Location failed, but continue with search anyway
                                          print('Location failed: $e');
                                        }
                                      }

                                      // Preserve existing filters when searching
                                      cubit.searchProviders(
                                        searchKey: value.isNotEmpty
                                            ? value
                                            : null,
                                        categoryId: cubit.selectedCategoryId,
                                        governmentId:
                                            cubit.selectedGovernmentId,
                                        cityId: cubit.selectedCityId,
                                        resetPage: true,
                                        context: context,
                                      );
                                    },
                                  ),
                                ),

                                SizedBox(height: 16.h),

                                // Providers List
                                SizedBox(
                                  height: 500.h,
                                  child: NetworkProvidersList(
                                    scrollController: _scrollController,
                                    isLoadingMore: _isLoadingMore,
                                    firstNavigateKey: _navigateKey,
                                    firstPhoneKey: _phoneKey,
                                  ),
                                ),
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
      ),
    );
  }
}
