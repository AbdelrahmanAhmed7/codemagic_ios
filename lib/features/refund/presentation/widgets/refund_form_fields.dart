import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class RefundAmountField extends StatelessWidget {
  final TextEditingController controller;

  const RefundAmountField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount',
          style: AppTextStyles.font14BlackMedium(context),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter amount',
            hintStyle: AppTextStyles.font14GreyRegular(context),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 8.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: AppColors.greyClr.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: AppColors.greyClr.withValues(alpha: 0.2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RefundDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(BuildContext) onTap;

  const RefundDatePicker({
    super.key,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service Date',
          style: AppTextStyles.font14BlackMedium(context),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () => onTap(context),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.greyClr.withValues(alpha: 0.2),
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate == null
                      ? 'Select date'
                      : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                  style: selectedDate == null
                      ? AppTextStyles.font14GreyRegular(context)
                      : AppTextStyles.font14BlackMedium(context),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 20.w,
                  color: AppColors.greyClr,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
