import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class InfoBanner extends StatelessWidget {
  final String message;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;

  const InfoBanner({
    super.key,
    required this.message,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? const Color(0xffFFEDC4);
    final iColor = iconColor ?? Colors.orange.shade800;
    final tColor = textColor ?? Colors.orange.shade800;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: iColor, size: 16.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.font12GreyRegular(context).copyWith(
                color: tColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
