import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';

class LocationPermissionDialog extends StatelessWidget {
  final VoidCallback? onEnablePressed;

  const LocationPermissionDialog({
    super.key,
    this.onEnablePressed,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          // Back button does nothing — user must press Continue
        }
      },
      child: Dialog(
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
            // Location Icon Container
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryClr.withValues(alpha: 0.1),
                    AppColors.primaryClr.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryClr.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_on,
                    size: 40.sp,
                    color: AppColors.primaryClr,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Title
            Text(
              'location_permission.title'.tr(),
              style: AppTextStyles.font20BlackSemiBold(context),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 12.h),
            
            // Message
            Text(
              'location_permission.message'.tr(),
              style: AppTextStyles.font14GreyRegular(context),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 32.h),
            
            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onEnablePressed?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryClr,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  elevation: 0,
                ),
                child: Text(
                  'location_permission.enable_button'.tr(),
                  style: AppTextStyles.font16WhiteMedium(context),
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  /// Show location permission dialog
  static Future<void> show(
    BuildContext context, {
    VoidCallback? onEnablePressed,
    VoidCallback? onMaybeLaterPressed,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LocationPermissionDialog(
        onEnablePressed: onEnablePressed,
      ),
    );
  }
}
