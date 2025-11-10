import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class SuccessDialog extends StatelessWidget {
  final String message;
  final VoidCallback? onClose;

  const SuccessDialog({
    super.key,
    required this.message,
    this.onClose,
  });

  static Future<void> show(
    BuildContext context, {
    required String message,
    VoidCallback? onClose,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SuccessDialog(
        message: message,
        onClose: onClose,
      ),
    );
  }

  void _handleClose(BuildContext context) {
    Navigator.of(context).pop();
    onClose?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => _handleClose(context),
                child: Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.greyClr, width: 1),
                    color: AppColors.whiteClr,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: AppColors.primaryClr,
                    size: 16.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Success illustration image
            Image.asset(
              AppAssets.passwordChanged,
              width: 161.w,
              height: 220.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 24.h),

            // Success message
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.font14BlackMedium(context),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}
