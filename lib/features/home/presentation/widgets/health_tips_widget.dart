import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class HealthTipsWidget extends StatelessWidget {
  const HealthTipsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Health Tips',
          style: AppTextStyles.font18BlackSemiBold,
        ),
        
        SizedBox(height: 16.h),
        
        // Health Tip Card
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.whiteClr,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.greyClr.withValues(alpha: 0.15),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: AppColors.greyClr.withValues(alpha: 0.05),
                blurRadius: 30,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // Illustration
              Container(
                width: double.infinity,
                height: 120.h,
                decoration: BoxDecoration(
                  color: AppColors.lightGreyClr,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Stack(
                  children: [
                    // Shield with cross
                    Positioned(
                      left: 20.w,
                      top: 20.h,
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: AppColors.primaryClr,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: const Icon(
                          Icons.medical_services,
                          color: AppColors.whiteClr,
                        ),
                      ),
                    ),
                    
                    // Stethoscope
                    Positioned(
                      right: 30.w,
                      top: 30.h,
                      child: Icon(
                        Icons.healing,
                        color: AppColors.primaryClr,
                        size: 24.sp,
                      ),
                    ),
                    
                    // Medicine box
                    Positioned(
                      left: 30.w,
                      bottom: 30.h,
                      child: Icon(
                        Icons.medication,
                        color: AppColors.approvalColor,
                        size: 20.sp,
                      ),
                    ),
                    
                    // Calendar
                    Positioned(
                      right: 20.w,
                      bottom: 20.h,
                      child: Icon(
                        Icons.calendar_today,
                        color: AppColors.greyClr,
                        size: 18.sp,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 16.h),
              
              // Tip Content
              Text(
                'Get Regular Check-Ups',
                style: AppTextStyles.font16BlackMedium,
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 8.h),
              
              Text(
                'Annual health check-ups can help detect diseases early and keep you healthier for longer!',
                style: AppTextStyles.font14GreyRegular,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        
        SizedBox(height: 16.h),
        
        // Pagination Dots
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8.w,
                height: 8.h,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryClr,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 8.w,
                height: 8.h,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  color: AppColors.greyClr.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 8.w,
                height: 8.h,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  color: AppColors.greyClr.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
