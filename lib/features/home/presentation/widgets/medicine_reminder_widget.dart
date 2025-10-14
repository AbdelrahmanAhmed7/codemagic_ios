import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class MedicineReminderWidget extends StatelessWidget {
  const MedicineReminderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with See All
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Medicine Reminder',
              style: AppTextStyles.font18BlackSemiBold,
            ),
            GestureDetector(
              onTap: () {
                // Handle see all tap
              },
              child: Text(
                'See All',
                style: AppTextStyles.font14PrimaryMedium,
              ),
            ),
          ],
        ),
        
        SizedBox(height: 16.h),
        
        // Medicine Cards (horizontal scroll)
        SizedBox(
          height: 120.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildMedicineCard(
                medicineName: 'Paracetamol',
                time: '1 PM | After Meal',
                timeDisplay: '02:00 PM',
              ),
              SizedBox(width: 12.w),
              _buildMedicineCard(
                medicineName: 'Vitamin C',
                time: '1 PM',
                timeDisplay: '05:50 PM',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMedicineCard({
    required String medicineName,
    required String time,
    required String timeDisplay,
  }) {
    return Container(
      width: 160.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.whiteClr,
        borderRadius: BorderRadius.circular(12.r),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Medicine Icon and Time
          Row(
            children: [
              Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryClr.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(
                  Icons.medication,
                  color: AppColors.primaryClr,
                  size: 14.sp,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.lightGreyClr,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      color: AppColors.greyClr,
                      size: 10.sp,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      timeDisplay,
                      style: AppTextStyles.font10GreyRegular,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12.h),
          
          // Medicine Name
          Text(
            medicineName,
            style: AppTextStyles.font14BlackMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          SizedBox(height: 4.h),
          
          // Time
          Text(
            time,
            style: AppTextStyles.font12GreyRegular,
          ),
        ],
      ),
    );
  }
}
