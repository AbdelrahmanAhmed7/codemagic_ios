import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/auth/signup/presentation/widgets/app_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  void _showSuccessDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
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
                  decoration: BoxDecoration(
                    color: Color(0xff64AB5E),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_circle,
                      color: Colors.white, size: 70.w),
                ),
                SizedBox(height: 43.h),
                Text(
                  "Congratulations!",
                  style: AppTextStyles.font20BlackSemiBold.copyWith(
                    fontSize: 24.sp,
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  "Password changed successfully You’ll be redirected to the login screen now",
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
      Navigator.of(context).pop();

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
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    Text(
                      'Reset Password',
                      style: AppTextStyles.font20BlackSemiBold,
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
                  "Create a new password. Ensure it differs from the previous one for security.",
                  style: AppTextStyles.font14GreyRegular,
                  textAlign: TextAlign.start,
                ),

                SizedBox(height: 40.h),

                Text(
                  "New Password",
                  style: AppTextStyles.font14BlackMedium,
                ),
                SizedBox(height: 8.h),
                AppTextField(
                  controller: _newPasswordController,
                  hintText: "Create Password",
                  isPassword: _obscureNewPassword,
                  prefixImagePath: AppAssets.passwordIcon,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a new password";
                    }
                    if (value.length < 8) {
                      return "Password must be at least 8 characters";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20.h),

                Text(
                  "Confirm Password",
                  style: AppTextStyles.font14BlackMedium,
                ),
                SizedBox(height: 8.h),
                AppTextField(
                  controller: _confirmPasswordController,
                  hintText: "Confirm Password",
                  isPassword: _obscureConfirmPassword,
                  prefixImagePath: AppAssets.passwordIcon,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please confirm your password";
                    }
                    if (value != _newPasswordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 40.h),

                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: Connect to reset password API
                      _showSuccessDialog();
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 56.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4285F4), Color(0xFF0139FE)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Confirm",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
