import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class UpcomingLabCard extends StatelessWidget {
  const UpcomingLabCard({super.key, this.assetImagePath});

  final String? assetImagePath;

  @override
  Widget build(BuildContext context) {
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
                      'Upcoming Lab Tests',
                      style: AppTextStyles.font14BlueRegular,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Next tests due in 2 months',
                      style: AppTextStyles.font12BlueRegular
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
          right: -15.w,
          top: -40.h,
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