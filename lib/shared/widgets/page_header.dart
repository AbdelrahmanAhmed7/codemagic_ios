import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({super.key, required this.title, this.onBack});

  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 136.h,
      decoration: BoxDecoration(
        color: AppColors.primaryClr,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
        child: Row(
          children: [
            Container(
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
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                onPressed: onBack ?? () => context.pop(),
              ),
            ),
            SizedBox(width: 28.w),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.font18BlackSemiBold.copyWith(
                  color: AppColors.whiteClr,
                ),
              ),
            ),
            Container(
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
          ],
        ),
      ),
    );
  }
}


