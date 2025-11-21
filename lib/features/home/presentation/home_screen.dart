import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/home/presentation/cubit/cubit/home_cubit.dart';
import 'package:mediconsult/features/home/presentation/cubit/cubit/home_state.dart';
import 'package:mediconsult/features/home/presentation/widgets/home_header_widget.dart';
import 'package:mediconsult/features/home/presentation/widgets/user_plan_card_widget.dart';
import 'package:mediconsult/features/home/presentation/widgets/quick_access_widget.dart';
import 'package:mediconsult/features/home/presentation/widgets/khusm_promotion_widget.dart';
import 'package:mediconsult/features/home/presentation/widgets/ongoing_request_widget.dart';
import 'package:mediconsult/features/home/presentation/widgets/health_tips_widget.dart';
import 'package:mediconsult/features/home/presentation/widgets/explore_widget.dart';
import 'package:mediconsult/features/home/presentation/widgets/bottom_navigation_bar_widget.dart';
import 'package:mediconsult/features/home/presentation/widgets/home_loading_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    context.read<HomeCubit>().getHomeInfo('en');
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
                    await context.read<HomeCubit>().refreshHomeInfo('en');
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                    children: [
                      HomeHeaderWidget(data: data!),
                      Stack(
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
                            child: UserPlanCardWidget(
                              data: data,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 80.h),
                      Container(
                        color: AppColors.lightGreyClr,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const QuickAccessWidget(),
                            SizedBox(height: 24.h),
                            const KhusmPromotionWidget(),
                            SizedBox(height: 24.h),
                            if (data.approvals.isNotEmpty) ...[
                              OngoingRequestWidget(data: data), 
                              SizedBox(height: 24.h),
                            ],
                            const HealthTipsWidget(),
                            SizedBox(height: 24.h),
                            const ExploreWidget(),
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
                      'An error occurred while loading the data',
                      style: AppTextStyles.font16BlackMedium,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      message,
                      style: AppTextStyles.font14GreyRegular,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<HomeCubit>().retry('en');
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryClr,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
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
            _currentIndex = index;
          });
          if (index == 3) context.go('/profile');
        },
      ),
    );
  }
}
