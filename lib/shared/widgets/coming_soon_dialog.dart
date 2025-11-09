import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class ComingSoonDialog extends StatelessWidget {
  final String? title;
  final String? message;

  const ComingSoonDialog({
    super.key,
    this.title,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Container(
        padding: EdgeInsets.all(32.w),
        decoration: BoxDecoration(
          color: AppColors.whiteClr,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated Icon Container
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryClr.withOpacity(0.1),
                    AppColors.primaryClr.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.rocket_launch_rounded,
                  size: 50.sp,
                  color: AppColors.primaryClr,
                ),
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Title
            Text(
              title ?? 'Coming Soon',
              style: AppTextStyles.font20BlackSemiBold(context),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 12.h),
            
            // Message
            Text(
              message ?? 'This feature is under development.\nStay tuned for updates!',
              style: AppTextStyles.font14GreyRegular(context),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 32.h),
            
            // Close Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryClr,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  elevation: 0,
                ),
                child: Text(
                  'Got it!',
                  style: AppTextStyles.font16WhiteMedium(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show coming soon dialog
  static Future<void> show(
    BuildContext context, {
    String? title,
    String? message,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ComingSoonDialog(
        title: title,
        message: message,
      ),
    );
  }
}
