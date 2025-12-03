import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:mediconsult/shared/widgets/custom_showcase.dart';
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
  bool _hasInitializedLocation = false;
  bool _isShowCaseActive = false;
  int _showcaseIndex = -1; // -1 means showcase is not active
  String? _previousSearchText;

  // Showcase keys
  final GlobalKey _categoriesKey = GlobalKey();
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _navigateKey = GlobalKey();
  final GlobalKey _phoneKey = GlobalKey();
  
  // Key to access NetworkSearchBar state
  final GlobalKey _searchBarKey = GlobalKey();

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
    _searchController.addListener(_onSearchTextChanged);
  }

  void _onSearchTextChanged() {
    // Skip listener if ShowCase is active to prevent freeze
    if (_isShowCaseActive) {
      _previousSearchText = _searchController.text;
      return;
    }

    if (!mounted) return;

    final currentText = _searchController.text;

    // لو النص اتغير من filled لـ empty، نرجع للقائمة الأصلية
    if (currentText.isEmpty &&
        _previousSearchText != null &&
        _previousSearchText!.isNotEmpty) {
      // Use Future.microtask to ensure this runs after current frame
      Future.microtask(() {
        if (!mounted || _isShowCaseActive) return;
        try {
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
        } catch (e) {
          // Ignore errors during showcase
        }
      });
    }
    _previousSearchText = currentText;
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
    // Only initialize location once per screen instance
    if (_hasInitializedLocation) return;
    
    final cubit = context.read<NetworkCubit>();

    // Check permission status first before showing dialog
    await cubit.requestLocationWithDialog(context);
    
    _hasInitializedLocation = true;
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
    _searchController.removeListener(_onSearchTextChanged);
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


  void _startShowcase() {
    // Ensure search field is unfocused before starting showcase
    FocusScope.of(context).unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    
    // Wait a frame to ensure unfocus is processed and widgets are built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Get available keys and find first available widget
        final keys = _getAvailableShowcaseKeys();
        int startIndex = 0;
        
        // Find first available widget
        for (int i = 0; i < keys.length; i++) {
          if (keys[i].currentContext != null) {
            startIndex = i;
            break;
          }
        }
        
        setState(() {
          _showcaseIndex = startIndex;
          _isShowCaseActive = true;
        });
      }
    });
  }

  void _nextShowcase() {
    final keys = _getAvailableShowcaseKeys();
    
    // Check if we can move to next step
    if (_showcaseIndex < keys.length - 1) {
      final nextIndex = _showcaseIndex + 1;
      final nextKey = keys[nextIndex];
      
      // Check if the widget for next step exists
      if (nextKey.currentContext != null) {
        setState(() {
          _showcaseIndex = nextIndex;
        });
      } else {
        // If widget doesn't exist, skip to next available or dismiss
        bool foundNext = false;
        for (int i = nextIndex + 1; i < keys.length; i++) {
          if (keys[i].currentContext != null) {
            setState(() {
              _showcaseIndex = i;
            });
            foundNext = true;
            break;
          }
        }
        
        // If no next widget found, dismiss showcase
        if (!foundNext) {
          _dismissShowcase();
        }
      }
    } else {
      _dismissShowcase();
    }
  }
  
  // Get available showcase keys based on current state
  List<GlobalKey> _getAvailableShowcaseKeys() {
    final keys = <GlobalKey>[];
    
    // Always add categories and search (they should always be available)
    if (_categoriesKey.currentContext != null) {
      keys.add(_categoriesKey);
    }
    if (_searchKey.currentContext != null) {
      keys.add(_searchKey);
    }
    
    // Only add navigate and phone keys if widgets exist
    final cubit = context.read<NetworkCubit>();
    final providers = cubit.currentProviders;
    final hasProviders = providers.isNotEmpty;
    
    if (hasProviders) {
      // Check if navigate widget exists
      if (_navigateKey.currentContext != null) {
        keys.add(_navigateKey);
      }
      // Check if phone widget exists
      if (_phoneKey.currentContext != null) {
        keys.add(_phoneKey);
      }
    }
    
    return keys;
  }
  
  // Get available showcase descriptions based on current state
  List<String> _getAvailableShowcaseDescriptions() {
    final descriptions = <String>[];
    
    // Always add categories and search descriptions (they should always be available)
    if (_categoriesKey.currentContext != null) {
      descriptions.add('tutorial.network.categories'.tr());
    }
    if (_searchKey.currentContext != null) {
      descriptions.add('tutorial.network.search'.tr());
    }
    
    // Only add navigate and phone descriptions if widgets exist
    final cubit = context.read<NetworkCubit>();
    final providers = cubit.currentProviders;
    final hasProviders = providers.isNotEmpty;
    
    if (hasProviders) {
      // Check if navigate widget exists
      if (_navigateKey.currentContext != null) {
        descriptions.add('tutorial.network.navigate'.tr());
      }
      // Check if phone widget exists
      if (_phoneKey.currentContext != null) {
        descriptions.add('tutorial.network.call'.tr());
      }
    }
    
    return descriptions;
  }

  void _dismissShowcase() {
    setState(() {
      _showcaseIndex = -1;
      _isShowCaseActive = false;
    });
    // Re-add the listener
    _searchController.addListener(_onSearchTextChanged);
  }

  // These are now dynamic getters
  List<GlobalKey> get _showcaseKeys => _getAvailableShowcaseKeys();
  List<String> get _showcaseDescriptions => _getAvailableShowcaseDescriptions();

  @override
  Widget build(BuildContext context) {
    return CustomShowcaseOverlay(
      targetKeys: _showcaseKeys,
      descriptions: _showcaseDescriptions,
      currentIndex: _showcaseIndex,
      onNext: _nextShowcase,
      onDismiss: _dismissShowcase,
      child: Scaffold(
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
                  onHelp: () async {
                    // Immediately remove listener to prevent any callbacks
                    _searchController.removeListener(_onSearchTextChanged);
                    
                    // Force unfocus search field multiple ways to ensure it works
                    FocusScope.of(context).unfocus();
                    FocusManager.instance.primaryFocus?.unfocus();
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    
                    // Try to unfocus through the search bar's focus node if accessible
                    final searchBarState = _searchBarKey.currentState;
                    if (searchBarState != null) {
                      try {
                        (searchBarState as dynamic).forceUnfocus();
                      } catch (e) {
                        // Ignore if method doesn't exist
                      }
                    }
                    
                    // Wait a bit to ensure focus is cleared and UI is stable
                    await Future.delayed(const Duration(milliseconds: 200));
                    
                    // Force unfocus again after delay
                    FocusScope.of(context).unfocus();
                    FocusManager.instance.primaryFocus?.unfocus();
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    
                    // Wait one more frame to ensure everything is settled
                    await Future.delayed(const Duration(milliseconds: 100));
                    
                    if (!mounted) return;
                    
                    // Start custom showcase
                    _startShowcase();
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

                                    return CustomShowcase(
                                      key: _categoriesKey,
                                      targetKey: _categoriesKey,
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
                                              // Preserve existing filters (government, city, and search) when selecting category
                                              cubit.searchProviders(
                                                searchKey: cubit.searchKey, // Preserve current search
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
                                CustomShowcase(
                                  key: _searchKey,
                                  targetKey: _searchKey,
                                  child: NetworkSearchBar(
                                    key: _searchBarKey,
                                    searchController: _searchController,
                                    isShowCaseActive: _isShowCaseActive,
                                    onUnfocusRequested: () {
                                      // Force unfocus when showcase starts
                                      FocusScope.of(context).unfocus();
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                                    },
                                    onFilterTap: _showFilterBottomSheet,
                                    onSearchSubmitted: (value) async {
                                      // Ensure search field remains enabled and focusable
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
                                      await cubit.searchProviders(
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
                                      
                                      // Ensure search field remains usable after search
                                      // Force rebuild to ensure TextField is enabled and focusable
                                      if (mounted) {
                                        // Ensure showcase is not active
                                        if (_isShowCaseActive) {
                                          _isShowCaseActive = false;
                                        }
                                        setState(() {});
                                        
                                        // Ensure focus node is available
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          if (mounted) {
                                            final searchBarState = _searchBarKey.currentState;
                                            if (searchBarState != null) {
                                              try {
                                                (searchBarState as dynamic).forceUnfocus();
                                              } catch (e) {
                                                // Ignore if method doesn't exist
                                              }
                                            }
                                          }
                                        });
                                      }
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
