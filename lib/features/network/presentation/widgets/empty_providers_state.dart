import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class EmptyProvidersState extends StatelessWidget {
  const EmptyProvidersState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            width: 200.w,
            height: 200.h,
            decoration: BoxDecoration(
              color: AppColors.lightGreyClr,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search,
              size: 80.sp,
              color: AppColors.primaryClr.withValues(alpha: 0.3),
            ),
          ),

          SizedBox(height: 24.h),

          // Title
          Text(
            'Search for Providers',
            style: AppTextStyles.font16BlackMedium(context),
          ),

          SizedBox(height: 8.h),

          // Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              'Use the search bar or filters to find nearby healthcare providers',
              style: AppTextStyles.font14GreyRegular(context),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
