import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/utils/app_button.dart';
import 'package:mediconsult/features/auth/signup/presentation/widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final cardOrPhoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    cardOrPhoneController.dispose();
    passwordController.dispose();
    super.dispose();
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
                      onPressed: () => context.go('/signup'),
                    ),
                    SizedBox(width: 50.w,),
                    Image.asset(
                      AppAssets.logo,
                      width: 172.w,
                      height: 38.h,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                SizedBox(height: 43.h),

                Text(
                  'Welcome back! Glad to see you,\n Again!',
                  style: AppTextStyles.font20BlackSemiBold,
                ),
                SizedBox(height: 12.h),
                Text(
                  'Please enter your Credentials to login',
                  style: AppTextStyles.font16GreyRegular,
                ),
                SizedBox(height: 40.h),

                Text(
                  'Card ID , National ID or Phone Number',
                  style: AppTextStyles.font16BlackMedium,
                ),
                SizedBox(height: 8.h),
                AppTextField(
                  controller: cardOrPhoneController,
                  hintText: 'Enter card number or Phone Number',
                  prefixImagePath: AppAssets.cardIcon,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Card ID, National ID, or Phone Number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                Text('Password', style: AppTextStyles.font16BlackMedium),
                SizedBox(height: 8.h),
                AppTextField(
                  controller: passwordController,
                  hintText: 'Enter Password',
                  isPassword: true,
                  prefixImagePath: AppAssets.passwordIcon,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.h),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.go('/forget-password');
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: AppColors.primaryClr,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 28.h),

                AppButton(
                  text: 'Login',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: Handle login API here
                    }
                  },
                ),
                SizedBox(height: 31.h),

                Center(
                  child: TextButton(
                    onPressed: () {
                      // TODO: Navigate to SignUp
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "Don’t have an account? ",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[700],
                        ),
                        children: [
                          TextSpan(
                            text: 'Register',
                            style: TextStyle(
                              color: AppColors.primaryClr,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.go('/sign-up');
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
