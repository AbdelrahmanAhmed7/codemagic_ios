import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class ActionRequiredDialog extends StatelessWidget {
  const ActionRequiredDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      contentPadding: EdgeInsets.all(20.w),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Placeholder illustration; user will add final asset
         Image.asset(AppAssets.actionRequired,width: 129,height: 138,),
          SizedBox(height: 12.h),
          Text(
            'Action Required: Upload Lab Tests',
            style: AppTextStyles.font14BlackMedium(context),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'To continue receiving your chronic medication, please upload all required lab test results.',
            style: AppTextStyles.font10GreyRegular(context),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ),
        ],
      ),
    );
  }
}


