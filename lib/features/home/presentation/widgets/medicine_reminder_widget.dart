import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class MedicineReminderWidget extends StatelessWidget {
  const MedicineReminderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Medicine Reminder', style: AppTextStyles.font14BlackMedium(context)),
            GestureDetector(
              onTap: () {},
              child: Text(
                'See All',
                style: AppTextStyles.font14PrimaryMedium(context).copyWith(
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 110.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildMedicineCard(
                medicineName: 'Paracetamol',
                dosage: '1 Pill',
                note: 'After Meal',
                time: '02:00 PM',
              ),
              SizedBox(width: 12.w),
              _buildMedicineCard(
                medicineName: 'Vitamin C',
                dosage: '1 Pill',
                note: 'Before Meal',
                time: '05:50 PM',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMedicineCard({
    required String medicineName,
    required String dosage,
    required String note,
    required String time,
    context
  }) {
    return Container(
      width: 280.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.whiteClr,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyClr.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60.w,
            height: 76.h,
            decoration: BoxDecoration(
              color: AppColors.primaryClr.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: Image.asset(
                AppAssets.medicines,
                width: 24.w,
                height: 24.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  medicineName,
                  style: AppTextStyles.font14PrimaryMedium(context).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Image.asset(
                      AppAssets.pillIcon,
                      width: 16.w,
                      height: 16.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 4.w),
                    Text(dosage, style: AppTextStyles.font12GreyRegular(context)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Text(
                        "|",
                        style: TextStyle(color: AppColors.greyClr),
                      ),
                    ),
                    Text(note, style: AppTextStyles.font12GreyRegular(context)),
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14.sp,
                      color: AppColors.greyClr,
                    ),
                    SizedBox(width: 4.w),
                    Text(time, style: AppTextStyles.font12GreyRegular(context)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}