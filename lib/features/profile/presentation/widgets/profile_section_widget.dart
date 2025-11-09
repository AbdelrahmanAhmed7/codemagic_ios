import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

/// Profile section widget (e.g., Account, Settings, Help & Support)
class ProfileSectionWidget extends StatelessWidget {
  final String title;
  final List<Widget> tiles;

  const ProfileSectionWidget({
    super.key,
    required this.title,
    required this.tiles,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),
              child: Text(
                title,
                style: AppTextStyles.font12BlueRegular(context),
              ),
            ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.whiteClr,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xffECECEC)),
            ),
            child: Column(children: tiles),
          ),
        ],
      ),
    );
  }
}

/// Profile tile widget (individual menu item)
class ProfileTileWidget extends StatelessWidget {
  final String title;
  final String image;
  final String? route;
  final VoidCallback? onTap;

  const ProfileTileWidget({
    super.key,
    required this.title,
    required this.image,
    this.route,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return ListTile(
      leading: Image.asset(image, width: 24.h, height: 24.h),
      title: Text(title, style: AppTextStyles.font12BlackRegular(context)),
      trailing: Transform.rotate(
        angle: isArabic ? 3.14 : 0,
        child: Image.asset(AppAssets.chevronRight, width: 24.w, height: 29.h),
      ),
      onTap: onTap ?? (route != null ? () => context.push(route!) : null),
    );
  }
}