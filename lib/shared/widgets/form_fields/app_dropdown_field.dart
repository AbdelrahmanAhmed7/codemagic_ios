import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class AppDropdownField<T> extends StatelessWidget {
  final T? value;
  final String? label;
  final bool isRequired;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
  final String? hintText;

  const AppDropdownField({
    super.key,
    this.value,
    this.label,
    this.isRequired = false,
    required this.items,
    required this.onChanged,
    this.validator,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
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
                            style: AppTextStyles.font12BlackRegular(context).copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ]
                      : [],
                ),
              ),
              SizedBox(height: 8.h),
            ],
            
            // Dropdown
            Container(
              decoration: BoxDecoration(
                color: AppColors.whiteClr,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.lightGreyClr),
              ),
              child: DropdownButtonFormField<T>(
                initialValue: value,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: AppTextStyles.font12GreyRegular(context),
                ),
                icon: const Icon(Icons.keyboard_arrow_down),
                items: items,
                onChanged: (newValue) {
                  onChanged(newValue);
                  fieldState.didChange(newValue);
                  fieldState.validate();
                },
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
