import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class RefundAmountField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const RefundAmountField({
    super.key, 
    required this.controller,
    this.focusNode,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'refund_request.amount'.tr(),
          style: AppTextStyles.font14BlackMedium(context),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: false,
          keyboardType: TextInputType.number,
          enableInteractiveSelection: true,
          onChanged: onChanged,
          onTapOutside: (_) {
            FocusScope.of(context).unfocus();
            SystemChannels.textInput.invokeMethod('TextInput.hide');
          },
          decoration: InputDecoration(
            hintText: 'placeholders.enter_amount'.tr(),
            hintStyle: AppTextStyles.font14GreyRegular(context),
            errorText: errorText,
            errorMaxLines: 2,
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
          'refund_request.service_date'.tr(),
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
                      ? 'placeholders.select_service_date'.tr()
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
