// file: widgets/app_text_field.dart
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
    return SizedBox(
      width: _width.w,
      height: _height.h,
      child: TextFormField(
        enabled: widget.enabled,
        validator: widget.validator,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: _obscure,
        onChanged: widget.onChanged,
        style: TextStyle(fontSize: 14.sp),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          hintText: widget.hintText,
          hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
          filled: true,
          fillColor: Colors.transparent,
          isDense: true,
          // prefix image
          prefixIcon: widget.prefixImagePath != null
              ? Padding(
                  padding: EdgeInsets.only(left: 12.w, right: 8.w),
                  child: Image.asset(
                    widget.prefixImagePath!,
                    width: 24.w,
                    height: 30.h,
                    fit: BoxFit.contain,
                  ),
                )
              : null,
          prefixIconConstraints: BoxConstraints(minWidth: 40.w, minHeight: 40.h),
          // suffix eye for password
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
          enabledBorder: _buildBorder(widget.errorText == null ? Colors.grey.shade300 : AppColors.errorClr),
          focusedBorder: _buildBorder(AppColors.primaryClr),
          errorBorder: _buildBorder(AppColors.errorClr),
          focusedErrorBorder: _buildBorder(AppColors.errorClr),
          errorText: widget.errorText,
        ),
      ),
    );
  }
}
