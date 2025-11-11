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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'policy_screen.medication_coverage'.tr(),
            style: AppTextStyles.font14BlackMedium(context),
          ),
          SizedBox(height: 12.h),
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      serviceIcon,
                      color: AppColors.primaryClr,
                      size: 16.sp,
                    ),
                    SizedBox(width: 6.w),
                    Flexible(
                      child: Text(
                        serviceName,
                        style: AppTextStyles.font10GreyRegular(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(width: 16.w),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$slLimit%',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryClr,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'policy_screen.standart_copayment'.tr(),
                    style: AppTextStyles.font10GreyRegular(context),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}