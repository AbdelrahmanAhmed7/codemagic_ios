import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
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
  final VoidCallback? onTap;
  final String? trailingAssetPath;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
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
                  Text(title, style: AppTextStyles.font14BlackMedium(context)),
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: AppTextStyles.font12GreyRegular(context),
                    ),
                  ],
                ],
              ),
            ),

            // Trailing Arrow
            Transform.rotate(
              angle: isArabic ? 3.14 : 0,
              child: Image.asset(
                AppAssets.chevronRight,
                width: 30.w,
                height: 30.w,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
