import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class ContactTile extends StatelessWidget {
  const ContactTile({
    super.key,
    this.assetPath,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailingAssetPath,
  });

  final String? assetPath;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? trailingAssetPath;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            // Leading Icon/Asset
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Image.asset(
                  assetPath!,
                  width: 40.w,
                  height: 40.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 12.w),

            // Title and Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: AppTextStyles.font12BlackRegular),
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(subtitle, style: AppTextStyles.font10GreyRegular),
                  ],
                ],
              ),
            ),

            // Trailing Arrow
            Image.asset(
              AppAssets.chevronRight,
              width: 30.w,
              height: 30.w,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
