import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class AppGenderSelector extends StatelessWidget {
  final String? selectedGender;
  final Function(String) onGenderChanged;
  final String? Function(String?)? validator;
  final bool isRequired;

  const AppGenderSelector({
    super.key,
    this.selectedGender,
    required this.onGenderChanged,
    this.validator,
    this.isRequired = false,
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
            RichText(
              text: TextSpan(
                text: 'personal_info.gender'.tr(),
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

            // Gender Options
            Row(
              children: [
                Expanded(
                  child: _buildGenderOption('Male', fieldState, context),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildGenderOption('Female', fieldState, context),
                ),
              ],
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

  Widget _buildGenderOption(
    String gender,
    FormFieldState<String> fieldState,
    context,
  ) {
    return GestureDetector(
      onTap: () {
        onGenderChanged(gender);
        fieldState.didChange(gender);
        fieldState.validate();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Radio<String>(
            value: gender,
            groupValue: selectedGender,
            activeColor: AppColors.primaryClr,
            onChanged: (value) {
              if (value != null) {
                onGenderChanged(value);
                fieldState.didChange(value);
                fieldState.validate();
              }
            },
          ),
          Text(gender, style: AppTextStyles.font12BlackRegular(context)),
        ],
      ),
    );
  }
}
