import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/auth/signup/presentation/widgets/app_text_field.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';

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
  
  bool _showErrorBanner = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      // Check if new password is different from old password
      if (_oldPasswordController.text == _newPasswordController.text) {
        setState(() {
          _showErrorBanner = true;
        });
        return;
      }

      setState(() {
        _showErrorBanner = false;
      });

      // TODO: Implement API call to change password
      final passwordData = {
        'oldPassword': _oldPasswordController.text,
        'newPassword': _newPasswordController.text,
      };
      
      print('Changing password: $passwordData');
      
      // Show success dialog
      _showSuccessDialog();
    }
  }

  Widget _showHintText() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffFFEDC4),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Color(0xffFFEDC4),
              size: 16.sp,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                'The new password must be different from the old password',
                style: AppTextStyles.font12GreyRegular,
              ),
            ),
          ],
        ),
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
                  style: AppTextStyles.font14BlackMedium,
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
                      style: AppTextStyles.font14WhiteMedium,
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
    return Scaffold(
      backgroundColor: AppColors.lightGreyClr,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const PageHeader(title: 'Change Password', backPath: '/profile'),
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _showHintText(),
                            SizedBox(height: 32.h),
                            // Error banner
                            if (_showErrorBanner) ...[
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: Colors.yellow.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(color: Colors.yellow.withValues(alpha: 0.3)),
                                ),
                                child: Text(
                                  'The new password must be different from the old password',
                                  style: AppTextStyles.font12BlackRegular.copyWith(
                                    color: Colors.orange.shade800,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                            ],
                            
                            // Old Password
                            Text(
                              'Old Password',
                              style: AppTextStyles.font14BlackMedium,
                            ),
                            SizedBox(height: 8.h),
                            AppTextField(
                              hintText: 'Enter old password',
                              controller: _oldPasswordController,
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Old password is required';
                                }
                                return null;
                              },
                            ),
                            
                            SizedBox(height: 16.h),
                            
                            // New Password
                            Text(
                              'New Password',
                              style: AppTextStyles.font14BlackMedium,
                            ),
                            SizedBox(height: 8.h),
                            AppTextField(
                              hintText: 'Enter new password',
                              controller: _newPasswordController,
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'New password is required';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters';
                                }
                                if (!value.contains(RegExp(r'[A-Z]'))) {
                                  return 'Password must include 1 uppercase letter';
                                }
                                return null;
                              },
                            ),
                            
                            SizedBox(height: 8.h),
                            
                            // Password requirements
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
                                    'Password must be at least 8 characters included 1 upper case',
                                    style: AppTextStyles.font12GreyRegular,
                                  ),
                                ),
                              ],
                            ),
                            
                            SizedBox(height: 16.h),
                            
                            // Confirm Password
                            Text(
                              'Confirm Password',
                              style: AppTextStyles.font14BlackMedium,
                            ),
                            SizedBox(height: 8.h),
                            AppTextField(
                              hintText: 'Confirm new password',
                              controller: _confirmPasswordController,
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != _newPasswordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            
                            SizedBox(height: 32.h),
                            
                            // Save button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _changePassword,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryClr,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                ),
                                child: Text(
                                  'Save',
                                  style: AppTextStyles.font16WhiteMedium,
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
      ),
    );
  }
}
