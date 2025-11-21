import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class RowUploadTile extends StatelessWidget {
  const RowUploadTile({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
    required this.onRemove,
    this.image,
    this.borderColor,
  });

  final String title;
  final String description;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final ImageProvider? image;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.whiteClr,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor ?? const Color(0xffECECEC)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50.w,
              height: 45.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.lightGreyClr,
              ),
              clipBehavior: Clip.antiAlias,
              child: image == null
                  ? Image.asset(AppAssets.uploadIcon, fit: BoxFit.contain)
                  : Image(image: image!, fit: BoxFit.cover),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.font12BlueRegular(context).copyWith(decoration: TextDecoration.none)),
                  SizedBox(height: 4.h),
                  Text(description, style: AppTextStyles.font8GreyRegular(context).copyWith(decoration: TextDecoration.none)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: onRemove,
              tooltip: 'Remove',
            ),
          ],
        ),
      ),
    );
  }
}


