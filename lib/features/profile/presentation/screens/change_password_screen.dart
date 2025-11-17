import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mediconsult/features/profile/presentation/cubit/change_password_cubit.dart';
import 'package:mediconsult/features/profile/presentation/cubit/change_password_state.dart';
import 'package:mediconsult/features/profile/presentation/widgets/password_field.dart';
import 'package:mediconsult/features/profile/presentation/widgets/success_dialog.dart';
import 'package:mediconsult/features/profile/presentation/widgets/info_banner.dart';

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
      context.read<ChangePasswordCubit>().changePassword(
        lang: context.locale.languageCode,
        oldPassword: _oldPasswordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
        confirmNewPassword: _confirmPasswordController.text.trim(),
      );
    }
  }

  String? _validateOldPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'change_password.validation.old_password_required'.tr();
    }
    return null;
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'change_password.validation.new_password_required'.tr();
    }
    if (value.length < 8) {
      return 'change_password.validation.password_length'.tr();
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'change_password.validation.confirm_password_required'.tr();
    }
    if (value != _newPasswordController.text) {
      return 'change_password.validation.passwords_not_match'.tr();
    }
    return null;
  }

  Widget _buildPasswordRequirements() {
    return Row(
      children: [
        Icon(Icons.info_outline, color: AppColors.primaryClr, size: 16.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            'change_password.password_requirements'.tr(),
            style: AppTextStyles.font12GreyRegular(context),
          ),
        ),
      ],
    );
  }

  void _showSuccessDialog() {
    SuccessDialog.show(
      context,
      messageKey: 'change_password.success_message',
      onClose: () => Navigator.of(context).pop(),
    );
  }

  Widget _buildForm(bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoBanner(message: 'change_password.hint'.tr()),
          SizedBox(height: 24.h),
          PasswordField(
            label: 'change_password.old_password'.tr(),
            hintText: 'change_password.old_password_placeholder'.tr(),
            controller: _oldPasswordController,
            validator: _validateOldPassword,
          ),
          SizedBox(height: 16.h),
          PasswordField(
            label: 'change_password.new_password'.tr(),
            hintText: 'change_password.new_password_placeholder'.tr(),
            controller: _newPasswordController,
            validator: _validateNewPassword,
            helperWidget: _buildPasswordRequirements(),
          ),
          SizedBox(height: 16.h),
          PasswordField(
            label: 'change_password.confirm_password'.tr(),
            hintText: 'change_password.confirm_password_placeholder'.tr(),
            controller: _confirmPasswordController,
            validator: _validateConfirmPassword,
          ),
          SizedBox(height: 32.h),
          _buildSubmitButton(isLoading),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _changePassword(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryClr,
          disabledBackgroundColor: AppColors.primaryClr.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.h),
        ),
        child: isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.whiteClr),
                ),
              )
            : Text(
                'common.save'.tr(),
                style: AppTextStyles.font16WhiteMedium(context),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    title: 'change_password.title'.tr(),
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
                              color: AppColors.greyClr.withValues(alpha: 0.08),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(24.w),
                          child: _buildForm(isLoading),
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
    );
  }
}