import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/utils/app_button.dart';
import 'package:mediconsult/features/auth/signup/presentation/widgets/app_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final cardController = TextEditingController();
  final nationalController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
                      onPressed: () => Navigator.pop(context),
                    ),
                    Image.asset(
                      'assets/logo/Logo.png',
                      width: 140.w,
                      height: 50.h,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                SizedBox(height: 40.h),
                Text(
                  'Hello! Register to get started',
                  style: AppTextStyles.font20BlackSemiBold,
                ),
                SizedBox(height: 12.h),
                Text(
                  'Please enter your Credentials',
                  style: AppTextStyles.font14GreyRegular,
                ),
                SizedBox(height: 24.h),

                Text('Card ID', style: AppTextStyles.font14BlackMedium),
                SizedBox(height: 8.h),
                AppTextField(
                  controller: cardController,
                  hintText: 'Enter card number',
                  prefixImagePath: AppAssets.cardIcon,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Card ID is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                Text.rich(
                  TextSpan(
                    text: 'National ID ',
                    style: AppTextStyles.font14BlackMedium,
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red, fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                AppTextField(
                  controller: nationalController,
                  hintText: 'Enter National ID',
                  prefixImagePath: AppAssets.idIcon,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'National ID is required';
                    }
                    if (value.length != 14 ||
                        !RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Enter a valid 14-digit National ID';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                Text.rich(
                  TextSpan(
                    text: 'Phone Number ',
                    style: AppTextStyles.font14BlackMedium,
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red, fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                AppTextField(
                  controller: phoneController,
                  hintText: 'Enter Phone Number',
                  prefixImagePath: AppAssets.phoneIcon,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    }
                    if (!RegExp(r'^(01)[0-9]{9}$').hasMatch(value)) {
                      return 'Enter a valid Egyptian phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                Text.rich(
                  TextSpan(
                    text: 'Password ',
                    style: AppTextStyles.font14BlackMedium,
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red, fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                AppTextField(
                  controller: passwordController,
                  hintText: 'Enter Password',
                  isPassword: true,
                  prefixImagePath: AppAssets.passwordIcon,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                Text.rich(
                  TextSpan(
                    text: 'Confirm Password ',
                    style: AppTextStyles.font14BlackMedium,
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red, fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                AppTextField(
                  controller: confirmPasswordController,
                  hintText: 'Enter Confirm Password',
                  isPassword: true,
                  prefixImagePath: AppAssets.passwordIcon,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm password is required';
                    } else if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),

                AppButton(
                  text: 'Register',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.go('/otp', extra: phoneController.text);
                    }
                  },
                ),
                SizedBox(height: 31.h),

                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: Text.rich(
                      TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[700],
                        ),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: AppColors.primaryClr,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.go('/login');
                              },
                          ),
                        ],
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
