import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class MonthHeader extends StatelessWidget {
  const MonthHeader({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final label = _formatMonthYear(date);
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF4E7C7),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(label, style: AppTextStyles.font12BlueRegular.copyWith(color: AppColors.blackClr)),
      ),
    );
  }

  String _formatMonthYear(DateTime d) {
    const months = [
      'January','February','March','April','May','June','July','August','September','October','November','December'
    ];
    return '${months[d.month - 1]} ${d.year}';
  }
}


