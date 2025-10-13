import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/utils/app_button.dart';
import 'package:mediconsult/features/auth/signup/presentation/widgets/app_text_field.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundClr,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                    onPressed: () => context.go('/login'),
                  ),
                  SizedBox(width: 30.w,),
                  Text(
                    'Forgot Password',
                    style: AppTextStyles.font20BlackSemiBold,
                  ),
                ],
              ),
              SizedBox(height: 40.h),
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      AppAssets.forgetPassword,
                      width: 250.w,
                      height: 263.h,
                    ),
                    SizedBox(height: 38.h),
                    Text(
                      'Don’t worry ! It happens. Please enter your phone number and we will send the OTP to this phone number.',
                      style: AppTextStyles.font14GreyRegular,
                    ),
                    SizedBox(height: 24.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Phone Number',
                        style: AppTextStyles.font16BlackMedium,
                      ),
                    ),
                    SizedBox(height: 8.h,),
                    Form(
                      key: _formKey,
                      child: AppTextField(
                        controller: phoneNumberController,
                        hintText: 'Enter your phone number',
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 29.h,),
                    RichText(
                      text: TextSpan(
                        text: 'Do you want to change phone number ?',
                        style: AppTextStyles.font14GreyRegular,
                        children: [
                          TextSpan(
                            text: 'Contact Us',
                            style: const TextStyle(
                              color: AppColors.primaryClr,
                              fontWeight: FontWeight.w400,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Handle "Contact Us" tap
                              },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.h,),
                    AppButton(text: 'Send', onPressed: (){
                      if (_formKey.currentState!.validate()) {
                        context.go('/otp-password', extra: phoneNumberController.text);
                      }
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
