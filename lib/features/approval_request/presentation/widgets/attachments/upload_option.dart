import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/attachments/dotted_rrect_painter.dart';

class UploadOption extends StatelessWidget {
  const UploadOption({
    super.key,
    required this.label,
    required this.onTap,
    this.assetIcon,
    this.icon,
  });

  final String label;
  final VoidCallback onTap;
  final String? assetIcon;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CustomPaint(
        painter: DottedRRectBorderPainter(
          color: Color(0xffB3B3B3),
          radius: 12.r,
        ),
        child: Container(
          height: 150.h,
          decoration: BoxDecoration(
            color: AppColors.whiteClr,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.greyClr.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (assetIcon != null)
                Image.asset(
                  assetIcon!,
                  width: 80.w,
                  height: 80.w,
                  fit: BoxFit.contain,
                )
              else if (icon != null)
                Icon(icon, color: AppColors.primaryClr),
              SizedBox(height: 8.h),
              Text(label, style: AppTextStyles.font14BlackMedium(context)),
            ],
          ),
        ),
      ),
    );
  }
}




















