import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/cubit/reset_password_cubit.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/reset_password_state.dart';
import 'package:mediconsult/shared/widgets/app_snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String phoneNumber;
  const ResetPasswordScreen({super.key, required this.phoneNumber});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _obscureNewPassword = true;

  void _showSuccessDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Container(
            width: 345.w,
            height: 424.h,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 90.w,
                  height: 90.w,
                  decoration: const BoxDecoration(
                    color: Color(0xff64AB5E),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 70.w,
                  ),
                ),
                SizedBox(height: 43.h),
                Text(
                  'auth.reset_password.congratulations'.tr(),
                  style: AppTextStyles.font20BlackSemiBold.copyWith(
                    fontSize: 24.sp,
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'auth.reset_password.success_message'.tr(),
                  style: AppTextStyles.font14GreyRegular.copyWith(
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.of(context).pop();
      context.go('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundClr,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                      ),
                      onPressed: () => context.go(
                        '/otp-password',
                        extra: widget.phoneNumber,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'auth.reset_password.title'.tr(),
                      style: AppTextStyles.font20BlackSemiBold(context),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),

                SizedBox(height: 40.h),
                Center(
                  child: Image.asset(
                    AppAssets.resetPassword,
                    height: 151.h,
                    width: 233.w,
                  ),
                ),

                SizedBox(height: 24.h),

                Text(
                  'auth.reset_password.description'.tr(),
                  style: AppTextStyles.font14GreyRegular(context),
                  textAlign: TextAlign.start,
                ),

                SizedBox(height: 40.h),

                Text(
                  'auth.reset_password.new_password'.tr(),
                  style: AppTextStyles.font14BlackMedium(context),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscureNewPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'auth.reset_password.validation.new_password_required'
                          .tr();
                    }
                    if (value.length < 8) {
                      return 'auth.reset_password.validation.password_length'
                          .tr();
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'auth.reset_password.new_password_placeholder'
                        .tr(),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 12.w, right: 8.w),
                      child: Image.asset(
                        AppAssets.passwordIcon,
                        width: 16.w,
                        height: 24.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                    suffixIcon: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: 40.w,
                        minHeight: 40.h,
                      ),
                      icon: Icon(
                        _obscureNewPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 20.w,
                        color: Colors.grey[700],
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.transparent,
                    isDense: true,
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 40.w,
                      minHeight: 40.h,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: AppColors.primaryClr,
                        width: 1,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: AppColors.errorClr,
                        width: 1,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: AppColors.errorClr,
                        width: 1,
                      ),
                    ),
                    errorStyle: const TextStyle(height: 0, fontSize: 0),
                    errorMaxLines: 1,
                  ),
                ),

                SizedBox(height: 20.h),

                Text(
                  'auth.reset_password.confirm_password'.tr(),
                  style: AppTextStyles.font14BlackMedium(context),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureNewPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'auth.reset_password.validation.confirm_password_required'
                          .tr();
                    }
                    if (value != _newPasswordController.text) {
                      return 'auth.reset_password.validation.passwords_not_match'
                          .tr();
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'auth.reset_password.confirm_password_placeholder'
                        .tr(),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 12.w, right: 8.w),
                      child: Image.asset(
                        AppAssets.passwordIcon,
                        width: 16.w,
                        height: 24.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                    suffixIcon: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: 40.w,
                        minHeight: 40.h,
                      ),
                      icon: Icon(
                        _obscureNewPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 20.w,
                        color: Colors.grey[700],
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.transparent,
                    isDense: true,
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 40.w,
                      minHeight: 40.h,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: AppColors.primaryClr,
                        width: 1,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: AppColors.errorClr,
                        width: 1,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: AppColors.errorClr,
                        width: 1,
                      ),
                    ),
                    errorStyle: const TextStyle(height: 0, fontSize: 0),
                    errorMaxLines: 1,
                  ),
                ),

                SizedBox(height: 40.h),

                BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
                  listener: (context, state) {
                    if (state is Success) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showAppSnackBar(context, 'OTP Sent Successfully');
                      });
                    }
                    if (state is Failed) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showAppSnackBar(context, state.error, isError: true);
                      });
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is Loading;

                    return GestureDetector(
                      onTap: isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context
                                    .read<ResetPasswordCubit>()
                                    .resetPassword(
                                      widget.phoneNumber,
                                      _newPasswordController.text,
                                      _confirmPasswordController.text,
                                      context.locale.languageCode,
                                    );
                                _showSuccessDialog();
                              }
                            },
                      child: Container(
                        width: double.infinity,
                        height: 56.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: isLoading
                                ? [Colors.grey.shade400, Colors.grey.shade500]
                                : [
                                    const Color(0xFF4285F4),
                                    const Color(0xFF0139FE),
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: isLoading
                            ? SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'auth.reset_password.confirm_button'.tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
