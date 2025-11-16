import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class TabNavigation extends StatelessWidget {
  final bool isTermsSelected;
  final Function(bool) onTabChanged;

  const TabNavigation({
    super.key,
    required this.isTermsSelected,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteClr,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderClr),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(true),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: isTermsSelected ? AppColors.primaryClr.withValues(alpha: 0.1) : AppColors.whiteClr,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'terms_policy.terms'.tr(),
                  textAlign: TextAlign.center,
                  style: isTermsSelected 
                      ? AppTextStyles.font16BlackMedium(context).copyWith(
                          color: const Color(0xFF083D91),
                        )
                      : AppTextStyles.font16BlackMedium(context),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(false),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: !isTermsSelected ? AppColors.primaryClr.withValues(alpha: 0.1) : AppColors.whiteClr,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'terms_policy.privacy_policy'.tr(),
                  textAlign: TextAlign.center,
                  style: !isTermsSelected 
                      ? AppTextStyles.font16BlackMedium(context).copyWith(
                          color: const Color(0xFF083D91),
                        )
                      : AppTextStyles.font16BlackMedium(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
