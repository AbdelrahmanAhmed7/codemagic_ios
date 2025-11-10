import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mediconsult/core/di/service_locator.dart';
import 'package:mediconsult/features/profile/presentation/cubit/change_password_cubit.dart';
import 'package:mediconsult/features/profile/presentation/cubit/change_password_state.dart';
import 'package:mediconsult/features/auth/signup/presentation/widgets/app_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Call the cubit
      context.read<ChangePasswordCubit>().changePassword(
        lang: context.locale.languageCode,
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
        confirmNewPassword: _confirmPasswordController.text,
      );
    }
  }

  Widget _buildHintBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Color(0xffFFEDC4),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange.shade800, size: 16.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'The new password must be different from the old password',
              style: AppTextStyles.font12GreyRegular(
                context,
              ).copyWith(color: Colors.orange.shade800),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Container(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: AppColors.primaryClr,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.close,
                        color: AppColors.whiteClr,
                        size: 16.sp,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // Success illustration
                Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryClr.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: AppColors.primaryClr,
                    size: 60.sp,
                  ),
                ),

                SizedBox(height: 24.h),

                // Success message
                Text(
                  'Congratulations your password has been changed.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font14BlackMedium(context),
                ),

                SizedBox(height: 24.h),

                // OK button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryClr,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: Text(
                      'OK',
                      style: AppTextStyles.font14WhiteMedium(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChangePasswordCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.lightGreyClr,
        body: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
          listener: (context, state) {
            state.maybeWhen(
              success: (response) {
                _showSuccessDialog();
              },
              failed: (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            final isLoading = state.maybeWhen(
              loading: () => true,
              orElse: () => false,
            );

            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    PageHeader(
                      title: 'profile.change_password.title'.tr(),
                      backPath: '/profile',
                    ),
                    Transform.translate(
                      offset: Offset(0, -20.h),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.whiteClr,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.greyClr.withValues(
                                  alpha: 0.08,
                                ),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(24.w),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildHintBanner(),
                                  SizedBox(height: 24.h),

                                  // Old Password
                                  Text(
                                    'profile.change_password.old_password'.tr(),
                                    style: AppTextStyles.font14BlackMedium(
                                      context,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  AppTextField(
                                    hintText: 'Enter old password',
                                    controller: _oldPasswordController,
                                    isPassword: true,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'profile.change_password.validation.old_password_required'
                                            .tr();
                                      }
                                      return null;
                                    },
                                  ),

                                  SizedBox(height: 16.h),

                                  // New Password
                                  Text(
                                    'profile.change_password.new_password'.tr(),
                                    style: AppTextStyles.font14BlackMedium(
                                      context,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  AppTextField(
                                    hintText: 'Enter new password',
                                    controller: _newPasswordController,
                                    isPassword: true,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'profile.change_password.validation.new_password_required'
                                            .tr();
                                      }
                                      if (value.length < 8) {
                                        return 'profile.change_password.validation.password_length'
                                            .tr();
                                      }
                                      return null;
                                    },
                                  ),

                                  SizedBox(height: 8.h),

                                  // Password requirements
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: AppColors.primaryClr,
                                        size: 16.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: Text(
                                          'Password must be at least 8 characters',
                                          style:
                                              AppTextStyles.font12GreyRegular(
                                                context,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 16.h),

                                  // Confirm Password
                                  Text(
                                    'profile.change_password.confirm_password'
                                        .tr(),
                                    style: AppTextStyles.font14BlackMedium(
                                      context,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  AppTextField(
                                    hintText: 'Confirm Password',
                                    controller: _confirmPasswordController,
                                    isPassword: true,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'profile.change_password.validation.confirm_password_required'
                                            .tr();
                                      }
                                      if (value !=
                                          _newPasswordController.text) {
                                        return 'profile.change_password.validation.passwords_not_match'
                                            .tr();
                                      }
                                      return null;
                                    },
                                  ),

                                  SizedBox(height: 32.h),

                                  // Save button
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: isLoading
                                          ? null
                                          : () => _changePassword(context),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryClr,
                                        disabledBackgroundColor: AppColors
                                            .primaryClr
                                            .withOpacity(0.6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 16.h,
                                        ),
                                      ),
                                      child: isLoading
                                          ? SizedBox(
                                              height: 20.h,
                                              width: 20.w,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(AppColors.whiteClr),
                                              ),
                                            )
                                          : Text(
                                              'Save',
                                              style:
                                                  AppTextStyles.font16WhiteMedium(
                                                    context,
                                                  ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
