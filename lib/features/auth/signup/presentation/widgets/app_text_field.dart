import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool isPassword;
  final String? prefixImagePath;
  final String? errorText;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;
  final bool enabled;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.isPassword = false,
    this.prefixImagePath,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.enabled = true,
    this.validator,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = true;

  static const double _width = 343;
  static const double _height = 48;
  static const double _borderRadius = 8;

  @override
  void initState() {
    super.initState();
    if (!widget.isPassword) _obscure = false;
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(_borderRadius.r),
      borderSide: BorderSide(color: color, width: 1),
    );
  }

  @override
Widget build(BuildContext context) {
  return FormField<String>(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: widget.validator,
    builder: (fieldState) {
      final String? localError = fieldState.errorText;
      final String? externalError = widget.errorText;
      final String? effectiveError = externalError ?? localError;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _width.w,
            height: _height.h,
            child: TextField(
              enabled: widget.enabled,
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              obscureText: _obscure,
          onChanged: (value) {
            widget.onChanged?.call(value);
            fieldState.didChange(value);
            fieldState.validate();
          },
              style: TextStyle(fontSize: 14.sp),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                hintText: widget.hintText,
                hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
                filled: true,
                fillColor: AppColors.whiteClr,
                isDense: true,
                prefixIcon: widget.prefixImagePath != null
                    ? Padding(
                        padding: EdgeInsets.only(left: 12.w, right: 8.w),
                        child: Image.asset(
                          widget.prefixImagePath!,
                          width: 16.w,
                          height: 24.h,
                          fit: BoxFit.contain,
                        ),
                      )
                    : null,
                prefixIconConstraints: BoxConstraints(minWidth: 40.w, minHeight: 40.h),
                suffixIcon: widget.isPassword
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(minWidth: 40.w, minHeight: 40.h),
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                          size: 20.w,
                          color: Colors.grey[700],
                        ),
                        onPressed: () {
                          setState(() {
                            _obscure = !_obscure;
                          });
                        },
                      )
                    : null,
                enabledBorder: _buildBorder(Colors.grey.shade300),
                focusedBorder: _buildBorder(AppColors.primaryClr),
                errorBorder: _buildBorder(AppColors.errorClr),
                focusedErrorBorder: _buildBorder(AppColors.errorClr),
                errorStyle: const TextStyle(height: 0, fontSize: 0),
                errorMaxLines: 1,
              ),
            ),
          ),
          if (effectiveError != null)
            Padding(
              padding: EdgeInsets.only(top: 6.h, left: 8.w),
              child: Text(
                effectiveError,
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
