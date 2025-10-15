import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class FamilyMembersSelector extends StatelessWidget {
  const FamilyMembersSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final members = [
      ('Ahmed', AppAssets.ahmed),
      ('Noha', AppAssets.noha),
      ('Laila', AppAssets.laila),
      ('Ali', AppAssets.ali),
    ];

    return SizedBox(
      height: 80.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final (name, avatar) in members)
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 48.w,
                    height: 48.w,
                    child: ClipOval(
                      child: Image.asset(avatar, fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(name, style: AppTextStyles.font12BlueMedium, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

