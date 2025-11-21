import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class PolicyCoverageCard extends StatelessWidget {
  final String serviceName;
  final String slLimit;
  final IconData serviceIcon;

  const PolicyCoverageCard({
    super.key,
    required this.serviceName,
    required this.slLimit,
    required this.serviceIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F7FF),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'policy_screen.coverage'.tr(),
                  style: AppTextStyles.font14BlackMedium(context),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      serviceIcon,
                      color: AppColors.primaryClr,
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      serviceName,
                      style: AppTextStyles.font10GreyRegular(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  slLimit,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryClr,
                  ),
                ),
                Text(
                  'Limit',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font10GreyRegular(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
