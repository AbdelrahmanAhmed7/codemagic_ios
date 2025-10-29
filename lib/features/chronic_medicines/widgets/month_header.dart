import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class MonthHeader extends StatelessWidget {
  const MonthHeader({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    // ننسّق الشهر والسنة حسب اللغة الحالية
    final label = DateFormat.yMMMM(context.locale.toString()).format(date);

    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF4E7C7),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          label,
          style: AppTextStyles.font12BlueRegular(context)
              .copyWith(color: AppColors.blackClr),
        ),
      ),
    );
  }
}
