import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/error/app_error_handler.dart';
import 'package:mediconsult/features/home/presentation/cubit/cubit/home_cubit.dart';
import 'package:mediconsult/features/home/presentation/cubit/cubit/home_state.dart';
import 'package:flutter/material.dart';
import 'package:mediconsult/features/home/presentation/widgets/home_header_widget.dart';
import 'package:mediconsult/features/home/presentation/widgets/user_plan_card_widget.dart';
import 'package:mediconsult/features/home/presentation/widgets/quick_access_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mediconsult/features/home/presentation/widgets/khusm_promotion_widget.dart';
import 'package:mediconsult/features/home/presentation/widgets/ongoing_request_widget.dart';
import 'package:mediconsult/features/home/presentation/widgets/health_tips_widget.dart';
import 'package:mediconsult/features/home/presentation/widgets/explore_widget.dart';
import 'package:mediconsult/features/home/presentation/widgets/bottom_navigation_bar_widget.dart';
import 'package:mediconsult/features/home/presentation/widgets/home_loading_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/utils/language_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // call home info when the screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPermissionsAndLoadData();
    });
  }
  
  Future<void> _checkPermissionsAndLoadData() async {
    try {
      // Load home data regardless of permissions
      context.read<HomeCubit>().getHomeInfo(LanguageHelper.getLanguageCode(context));
    } catch (e) {
      // If there's an error, still try to load home data
      context.read<HomeCubit>().getHomeInfo(LanguageHelper.getLanguageCode(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreyClr,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeCubitState>(
          builder: (context, state) {
            return state.when(
              initial: () => const HomeLoadingWidget(),
              loading: () => const HomeLoadingWidget(),

              /// when the data is loaded, show the page with the real data
              loaded: (model) {
                final data = model.data;
                return RefreshIndicator(
                  onRefresh: () async {
                    await context.read<HomeCubit>().refreshHomeInfo(LanguageHelper.getLanguageCode(context));
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // Wrap header in RepaintBoundary for better performance
                        RepaintBoundary(
                          child: HomeHeaderWidget(data: data!),
                        ),
                        RepaintBoundary(
                          child: Stack(
                          clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 130.h,
                                color: AppColors.primaryClr,
                              ),
                              Positioned(
                                bottom: -70.h,
                                left: 16.w,
                                right: 16.w,
                                child: UserPlanCardWidget(data: data),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 80.h),
                        Container(
                          color: AppColors.lightGreyClr,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RepaintBoundary(
                                child: const QuickAccessWidget(),
                              ),
                              SizedBox(height: 24.h),
                              RepaintBoundary(
                                child: const KhusmPromotionWidget(),
                              ),
                              SizedBox(height: 24.h),
                              if (data.approvals.any((approval) => approval.status.toLowerCase() == 'reviewing')) ...[
                                RepaintBoundary(
                                  child: OngoingRequestWidget(data: data),
                                ),
                                SizedBox(height: 24.h),
                              ],
                              RepaintBoundary(
                                child: const HealthTipsWidget(),
                              ),
                              SizedBox(height: 24.h),
                              RepaintBoundary(
                                child: const ExploreWidget(),
                              ),
                              SizedBox(height: 40.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },

              /// in case of error
              failed: (message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64.w,
                      color: AppColors.errorClr,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'home.error_loading'.tr(),
                      style: AppTextStyles.font16BlackMedium(context),
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Text(
                        AppErrorHandler.getUserFriendlyMessage(message),
                        style: AppTextStyles.font14GreyRegular(context),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<HomeCubit>().retry(LanguageHelper.getLanguageCode(context));
                      },
                      icon: const Icon(Icons.refresh),
                      label: Text('common.retry'.tr()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryClr,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = 0;
          });
          if (index == 1) {
            context.push('/network');
          } else if (index == 2) {
            context.push('/approval-request');
          } else if (index == 3) {
            context.push('/profile');
          }
        },
      ),
    );
  }
}