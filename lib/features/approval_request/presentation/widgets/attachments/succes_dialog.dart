import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/utils/app_button.dart';

class SuccessDialog extends StatelessWidget {
  final String titleKey;
  final String subtitleKey;
  final String buttonTextKey;
  
  const SuccessDialog({
    super.key,
    this.titleKey = 'approval_request.success.title',
    this.subtitleKey = 'approval_request.success.subtitle',
    this.buttonTextKey = 'common.back_home',
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      backgroundColor: AppColors.whiteClr,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Illustration Container
              Container(
                width: 180.w,
                height: 180.h,
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
                titleKey.tr(),
                textAlign: TextAlign.center,
                style: AppTextStyles.font18BlackSemiBold(context),
              ),
              SizedBox(height: 12.h),
              
              // Subtitle
              Text(
                subtitleKey.tr(),
                textAlign: TextAlign.center,
                style: AppTextStyles.font14BlackMedium(context).copyWith(
                  color: AppColors.greyClr,
                ),
              ),
              SizedBox(height: 32.h),
              
              // Back Home Button
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: AppButton(
                  text: buttonTextKey.tr(),
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go('/home'); 
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Helper method to show the dialog for approval
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap button to close
      builder: (context) => const SuccessDialog(
        titleKey: 'approval_request.success.title',
        subtitleKey: 'approval_request.success.subtitle',
        buttonTextKey: 'common.back_home',
      ),
    );
  }
  
  // Helper method to show the dialog for refund
  static void showRefund(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap button to close
      builder: (context) => const SuccessDialog(
        titleKey: 'refund_request.success.title',
        subtitleKey: 'refund_request.success.subtitle',
        buttonTextKey: 'common.back_home',
      ),
    );
  }
}