import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class UpcomingLabCard extends StatelessWidget {
  const UpcomingLabCard({super.key, this.assetImagePath});

  final String? assetImagePath;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final direction = Directionality.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: const Color(0xFFE7F4F9),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            textDirection: direction,
            children: [
              SizedBox(
                width: 24.w,
                height: 24.w,
                child: Image.asset(AppAssets.upcoming, fit: BoxFit.contain),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'chronic_medicines.upcoming_lab_title'.tr(),
                      style: AppTextStyles.font14BlueRegular(context),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'chronic_medicines.upcoming_lab_subtitle'.tr(),
                      style: AppTextStyles.font12BlueRegular(context)
                          .copyWith(color: const Color(0xff4285F4)),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 60.w),
            ],
          ),
        ),
        Positioned(
          top: -40.h,
          right: isArabic ? null : -15.w,
          left: isArabic ? -15.w : null,
          child: Image.asset(
            AppAssets.aalem,
            width: 110.w,
            height: 110.w,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
