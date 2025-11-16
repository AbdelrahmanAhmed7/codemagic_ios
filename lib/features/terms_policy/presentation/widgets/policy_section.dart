import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class PolicySection extends StatelessWidget {
  final String title;
  final String? content;
  final List<String>? items;
  final bool useCheckmarks;
  final bool useIcons;
  final IconData? iconType;
  final String? email;
  final IconData? icon;

  const PolicySection({
    super.key,
    required this.title,
    this.content,
    this.items,
    this.useCheckmarks = false,
    this.useIcons = false,
    this.iconType,
    this.email,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.lightGreyClr.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: AppTextStyles.font14BlueMedium(context).copyWith(
              color: const Color(0xFF083D91),
            ),
          ),
          SizedBox(height: 12.h),
          
          // Content
          if (content != null) ...[
            Text(
              content!,
              style: AppTextStyles.font12BlackRegular(context),
            ),
            SizedBox(height: 8.h),
          ],
          
          // Items list
          if (items != null) ...[
            ...items!.map((item) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (useCheckmarks) ...[
                    Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: AppColors.whiteClr,
                        size: 12.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                  ] else if (useIcons && iconType != null) ...[
                    Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: AppColors.primaryClr,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        iconType!,
                        color: AppColors.whiteClr,
                        size: 12.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                  ] else ...[
                    Container(
                      width: 6.w,
                      height: 6.w,
                      margin: EdgeInsets.only(top: 6.h, right: 8.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryClr,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                  Expanded(
                    child: Text(
                      item,
                      style: AppTextStyles.font12BlackRegular(context),
                    ),
                  ),
                ],
              ),
            )),
          ],
          
          // Email with icon
          if (email != null) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  icon ?? Icons.email,
                  color: AppColors.primaryClr,
                  size: 16.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  email!,
                  style: AppTextStyles.font12BlackRegular(context).copyWith(
                    color: AppColors.primaryClr,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
