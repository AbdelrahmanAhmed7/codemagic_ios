import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class HealthTipsWidget extends StatelessWidget {
  const HealthTipsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'home.health_tips'.tr(),
          style: AppTextStyles.font16BlackMedium(context).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 165.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xffCBDCF9),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textDirection: isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: isArabic ? 0 : 12.w,
                    left: isArabic ? 12.w : 0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'home.health_tips_title'.tr(),
                        style: AppTextStyles.font14BlackMedium(context).copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'home.health_tips_description'.tr(),
                        style: AppTextStyles.font14GreyRegular(context).copyWith(
                          height: 1.3,
                          fontSize: 12.sp,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  AppAssets.checkUp,
                  width: 110.w,
                  height: 110.h,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8.w,
                height: 8.h,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: const BoxDecoration(
                  color: Color(0xff484848),
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
