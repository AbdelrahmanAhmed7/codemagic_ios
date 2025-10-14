import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
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

  // Sample data - سيتم استبدالها بـ API لاحقاً
  final bool _hasOngoingRequests = true; // سيتم التحكم بها من الـ API
  final bool _hasMedicineReminders = true; // سيتم التحكم بها من الـ API

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteClr,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              const HomeHeaderWidget(),
              
              // Blue background extension
              Container(
                width: double.infinity,
                height: 110.h,
                color: AppColors.primaryClr,
              ),
              
              // Main Content
              Container(
                color: AppColors.whiteClr,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Plan Card with negative margin to overlap blue
                    Transform.translate(
                      offset: Offset(0, -80.h),
                      child: UserPlanCardWidget(
                        planType: PlanType.gold, // يمكن تغييرها
                        userName: 'Ahmed Mohamed Adel Amin',
                        cardId: '976875',
                        expireDate: '12/2028',
                      ),
                    ),
                    
                    SizedBox(height: 0.h),
                    
                    // Quick Access
                    const QuickAccessWidget(),
                    
                    SizedBox(height: 24.h),
                    
                    // Khusm Promotion
                    const KhusmPromotionWidget(),
                    
                    SizedBox(height: 24.h),
                    
                    // Ongoing Request (conditional)
                    if (_hasOngoingRequests) ...[
                      const OngoingRequestWidget(),
                      SizedBox(height: 24.h),
                    ],
                    
                    // Medicine Reminder (conditional)
                    if (_hasMedicineReminders) ...[
                      const MedicineReminderWidget(),
                      SizedBox(height: 24.h),
                    ],
                    
                    // Health Tips
                    const HealthTipsWidget(),
                    
                    SizedBox(height: 24.h),
                    
                    // Explore
                    const ExploreWidget(),
                    
                    SizedBox(height: 100.h), // Bottom padding for navigation bar
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
        },
      ),
    );
  }
}

// أنواع الخطط المختلفة
enum PlanType {
  gold,
  silver,
  bronze,
  platinum,
  diamond,
}
