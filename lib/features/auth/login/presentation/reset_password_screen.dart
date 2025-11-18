import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/widgets/auth_base_layout.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/cubit/reset_password_cubit.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/reset_password_state.dart';
import 'package:mediconsult/shared/widgets/app_snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mediconsult/features/auth/signup/presentation/widgets/app_text_field.dart';

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
                  style: AppTextStyles.font20BlackSemiBold(
                    context,
                  ).copyWith(fontSize: 24.sp, decoration: TextDecoration.none),
                ),
                SizedBox(height: 16.h),
                Text(
                  'auth.reset_password.success_message'.tr(),
                  style: AppTextStyles.font14GreyRegular(
                    context,
                  ).copyWith(decoration: TextDecoration.none),
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
    return AuthBaseLayout(
      title: 'auth.reset_password.title'.tr(),
      onBack: () => context.push('/otp-password', extra: widget.phoneNumber),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Image =====
            Center(
              child: Image.asset(
                AppAssets.resetPassword,
                height: 151.h,
                width: 233.w,
              ),
            ),

            SizedBox(height: 24.h),

            // ===== Description =====
            Text(
              'auth.reset_password.description'.tr(),
              style: AppTextStyles.font14GreyRegular(context),
              textAlign: TextAlign.start,
            ),

            SizedBox(height: 40.h),

            // ===== New Password =====
            Text(
              'auth.reset_password.new_password'.tr(),
              style: AppTextStyles.font14BlackMedium(context),
            ),
            SizedBox(height: 8.h),
            AppTextField(
              controller: _newPasswordController,
              hintText: 'auth.reset_password.new_password_placeholder'.tr(),
              isPassword: true,
              prefixImagePath: AppAssets.passwordIcon,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'auth.reset_password.validation.new_password_required'
                      .tr();
                }
                if (value.length < 8) {
                  return 'auth.reset_password.validation.password_length'.tr();
                }
                return null;
              },
            ),

            SizedBox(height: 20.h),

            // ===== Confirm Password =====
            Text(
              'auth.reset_password.confirm_password'.tr(),
              style: AppTextStyles.font14BlackMedium(context),
            ),
            SizedBox(height: 8.h),
            AppTextField(
              controller: _confirmPasswordController,
              hintText: 'auth.reset_password.confirm_password_placeholder'.tr(),
              isPassword: true,
              prefixImagePath: AppAssets.passwordIcon,
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
            ),

            SizedBox(height: 40.h),

            // ===== Button =====
            BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
              listener: (context, state) {
                if (state is Success) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showSuccessDialog();
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
                            context.read<ResetPasswordCubit>().resetPassword(
                              widget.phoneNumber,
                              _newPasswordController.text,
                              _confirmPasswordController.text,
                              context.locale.languageCode,
                            );
                          }
                        },
                  child: Container(
                    width: double.infinity,
                    height: 56.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
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
    );
  }
}