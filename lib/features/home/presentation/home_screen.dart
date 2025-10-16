import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/features/home/presentation/widgets/home_header_widget.dart';
import 'package:mediconsult/features/home/presentation/widgets/user_plan_card_widget.dart';
import 'package:mediconsult/features/home/presentation/widgets/quick_access_widget.dart';
import 'package:mediconsult/features/home/presentation/widgets/khusm_promotion_widget.dart';
import 'package:mediconsult/features/home/presentation/widgets/ongoing_request_widget.dart';
import 'package:mediconsult/features/home/presentation/widgets/medicine_reminder_widget.dart';
import 'package:mediconsult/features/home/presentation/widgets/health_tips_widget.dart';
import 'package:mediconsult/features/home/presentation/widgets/explore_widget.dart';
import 'package:mediconsult/features/home/presentation/widgets/bottom_navigation_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final bool _hasOngoingRequests = true;
  final bool _hasMedicineReminders = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreyClr,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const HomeHeaderWidget(),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: 130.h, 
                    color: AppColors.primaryClr,
                  ),
                  Positioned(
                    bottom: -60.h,
                    left: 16.w,
                    right: 16.w,
                    child: UserPlanCardWidget(
                      planType: PlanType.gold,
                      userName: 'Ahmed Mohamed Adel Amin',
                      cardId: '976875',
                      expireDate: '12/2028',
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 80.h,
              ), 
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
                    if (_hasOngoingRequests) ...[
                      const OngoingRequestWidget(),
                      SizedBox(height: 24.h),
                    ],
                    if (_hasMedicineReminders) ...[
                      const MedicineReminderWidget(),
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
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 3) {
            context.go('/profile');
          }
        },
      ),
    );
  }
}

enum PlanType { gold, silver, bronze, platinum, diamond }