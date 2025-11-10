import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/auth/signup/presentation/widgets/app_text_field.dart';

class PasswordField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Widget? helperWidget;

  const PasswordField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.validator,
    this.helperWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.font14BlackMedium(context),
        ),
        SizedBox(height: 8.h),
        AppTextField(
          hintText: hintText,
          controller: controller,
          isPassword: true,
          validator: validator,
        ),
        if (helperWidget != null) ...[
          SizedBox(height: 8.h),
          helperWidget!,
        ],
      ],
    );
  }
}
