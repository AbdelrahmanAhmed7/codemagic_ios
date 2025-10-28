import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Agent illustration
            Image.asset(
              AppAssets.chatAgent,
              width: 120.w,
              height: 120.w,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 24.h),
            
            // Welcome text
            Text(
              'How can we help you?',
              style: AppTextStyles.font16BlackMedium(context),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            
            // Subtitle with icon
            Text(
              'Start by typing your question below! ⬇️',
              style: AppTextStyles.font12GreyRegular(context),
            ),
            SizedBox(height: 32.h),
            
            // Arrow pointing down
            Image.asset(
              AppAssets.arrow,
              width: 80.w,
              height: 80.w,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
