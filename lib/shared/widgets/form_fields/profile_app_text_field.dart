import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class ProfileAppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? label;
  final bool isPassword;
  final String? prefixImagePath;
  final String? errorText;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;
  final bool enabled;
  final String? Function(String?)? validator;
  final bool isRequired;
  final int maxLines;
  final Widget? suffixIcon;
  final bool readOnly;

  const ProfileAppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.label,
    this.isPassword = false,
    this.prefixImagePath,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.enabled = true,
    this.validator,
    this.isRequired = false,
    this.maxLines = 1,
    this.suffixIcon,
    this.readOnly = false,
  });

  @override
  State<ProfileAppTextField> createState() => _ProfileAppTextFieldState();
}

class _ProfileAppTextFieldState extends State<ProfileAppTextField> {
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    if (!widget.isPassword) _obscure = false;
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
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
            // Label with required asterisk
            if (widget.label != null) ...[
              RichText(
                text: TextSpan(
                  text: widget.label!,
                  style: AppTextStyles.font14BlackMedium(context),
                  children: widget.isRequired
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
            
            // TextField
            SizedBox(
              height: widget.maxLines > 1 ? null : 48.h,
              child: TextField(
                enabled: widget.enabled,
                readOnly: widget.readOnly,
                controller: widget.controller,
                keyboardType: widget.keyboardType,
                obscureText: widget.isPassword ? _obscure : false,
                maxLines: widget.maxLines,
                onChanged: (value) {
                  widget.onChanged?.call(value);
                  fieldState.didChange(value);
                  fieldState.validate();
                },
                style: widget.readOnly
                    ? AppTextStyles.font12GreyRegular(context).copyWith(color: AppColors.greyClr)
                    : AppTextStyles.font12GreyRegular(context),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  hintText: widget.hintText,
                  hintStyle: AppTextStyles.font12GreyRegular(context),
                  filled: true,
                  fillColor: widget.readOnly ? AppColors.lightGreyClr : AppColors.whiteClr,
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
                  suffixIcon: widget.suffixIcon ?? (widget.isPassword
                      ? ConstrainedBox(
                          constraints: BoxConstraints(minWidth: 40.w, minHeight: 40.h),
                          child: Padding(
                            padding: EdgeInsets.zero,
                            child: IconButton(
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
                            ),
                          ),
                        )
                      : null),
                  enabledBorder: _buildBorder(widget.readOnly ? AppColors.lightGreyClr : AppColors.borderClr),
                  focusedBorder: _buildBorder(widget.readOnly ? AppColors.lightGreyClr : AppColors.borderClr),
                  errorBorder: _buildBorder(AppColors.errorClr),
                  focusedErrorBorder: _buildBorder(AppColors.errorClr),
                  errorStyle: const TextStyle(height: 0, fontSize: 0),
                  errorMaxLines: 1,
                ),
              ),
            ),
            
            // Error message
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
