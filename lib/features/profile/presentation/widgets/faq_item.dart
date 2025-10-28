import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class FaqItem extends StatelessWidget {
  const FaqItem({super.key, required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.whiteClr,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyClr.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(question, style: AppTextStyles.font14BlackMedium(context)),
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(answer, style: AppTextStyles.font12BlackRegular(context)),
          ),
        ],
      ),
    );
  }
}