import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class AppDateField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final bool isRequired;
  final String? Function(String?)? validator;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const AppDateField({
    super.key,
    required this.controller,
    this.label,
    this.isRequired = false,
    this.validator,
    this.initialDate,
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      builder: (fieldState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label with required asterisk
            if (label != null) ...[
              RichText(
                text: TextSpan(
                  text: label!,
                  style: AppTextStyles.font14BlackMedium(context),
                  children: isRequired
                      ? [
                          TextSpan(
                            text: ' *',
                            style: AppTextStyles.font12BlackRegular(
                              context,
                            ).copyWith(color: Colors.red),
                          ),
                        ]
                      : [],
                ),
              ),
              SizedBox(height: 8.h),
            ],

            // Date Field
            Container(
              decoration: BoxDecoration(
                color: AppColors.whiteClr,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.borderClr),
              ),
              child: TextField(
                controller: controller,
                readOnly: true,
                style: AppTextStyles.font12GreyRegular(context),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  border: InputBorder.none,
                  hintText: 'DD/MM/YYYY',
                  hintStyle: AppTextStyles.font12GreyRegular(context),
                  suffixIcon: Icon(
                    Icons.date_range_outlined,
                    size: 20.sp,
                    color: AppColors.greyClr,
                  ),
                ),
                onTap: () async {},
              ),
            ),

            // Error message
            if (fieldState.errorText != null)
              Padding(
                padding: EdgeInsets.only(top: 6.h, left: 8.w),
                child: Text(
                  fieldState.errorText!,
                  style: TextStyle(
                    color: AppColors.errorClr,
                    fontSize: 12.sp,
                    height: 1.2,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
