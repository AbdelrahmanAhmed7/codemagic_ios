import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

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
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
      width: double.infinity,
      height: 136.h,
      decoration: BoxDecoration(
        color: AppColors.primaryClr,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24.r)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
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
                  icon: Transform.rotate(
                    angle: isRtl ? 3.14 : 0,
                    child: const Icon(Icons.arrow_back_ios_new, size: 18),
                  ),
                  onPressed:
                      onBack ??
                      () => backPath != null
                          ? context.go(backPath!)
                          : context.pop(),
                ),
              ),
            ),
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.font18BlackSemiBold(
                  context,
                ).copyWith(color: AppColors.whiteClr),
              ),
            ),

            Align(
              alignment: isRtl ? Alignment.centerLeft : Alignment.centerRight,
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