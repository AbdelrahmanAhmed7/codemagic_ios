import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.onBack,
    this.backPath,
  });

  final String title;
  final VoidCallback? onBack;
  final String? backPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 136.h,
      decoration: BoxDecoration(
        color: AppColors.primaryClr,
        borderRadius: BorderRadius.only(
          bottomLeft: context.locale.languageCode == 'ar' ? Radius.circular(0) : Radius.circular(24.r),
          bottomRight: context.locale.languageCode == 'ar' ? Radius.circular(24.r) : Radius.circular(0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // back button on the left
            Align(
              alignment: context.locale.languageCode == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: AppColors.whiteClr,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.greyClr.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: context.locale.languageCode == 'ar' 
                      ? const Icon(Icons.arrow_forward_ios, size: 18)
                      : const Icon(Icons.arrow_back_ios_new, size: 18),
                  onPressed: onBack ??
                      () => backPath != null
                          ? context.go(backPath!)
                          : context.pop(),
                ),
              ),
            ),

            // title in the center
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.font18BlackSemiBold.copyWith(
                  color: AppColors.whiteClr,
                ),
              ),
            ),

            // azimuth icon on the right
            Align(
              alignment: context.locale.languageCode == 'ar' ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: 28.w,
                height: 28.w,
                decoration: const BoxDecoration(
                  color: AppColors.whiteClr,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  CupertinoIcons.question,
                  color: AppColors.blackClr,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}