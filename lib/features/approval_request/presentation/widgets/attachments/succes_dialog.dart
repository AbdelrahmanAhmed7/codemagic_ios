import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/utils/app_button.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      backgroundColor: AppColors.whiteClr,
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Illustration Container
            Container(
              width: 200.w,
              height: 200.h,
              decoration: BoxDecoration(
                color: AppColors.primaryClr.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(AppAssets.success)
              ),
            ),
            SizedBox(height: 24.h),
            
            // Title
            Text(
              'Approval Request Submitted Successfully',
              textAlign: TextAlign.center,
              style: AppTextStyles.font18BlackSemiBold(context),
            ),
            SizedBox(height: 12.h),
            
            // Subtitle
            Text(
              'We\'ll notify you once your request is approved',
              textAlign: TextAlign.center,
              style: AppTextStyles.font14BlackMedium.copyWith(
                color: AppColors.greyClr,
              ),
            ),
            SizedBox(height: 32.h),
            
            // Back Home Button
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: AppButton(
                text: 'Back Home',
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/home'); 
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper method to show the dialog
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap button to close
      builder: (context) => const SuccessDialog(),
    );
  }
}