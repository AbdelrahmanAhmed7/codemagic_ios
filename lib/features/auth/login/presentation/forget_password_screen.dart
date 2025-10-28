import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/utils/app_button.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/cubit/send_otp_cubit.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/send_otp_state.dart';
import 'package:mediconsult/features/auth/signup/presentation/widgets/app_text_field.dart';
import 'package:mediconsult/shared/widgets/app_snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';

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
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                    ),
                    onPressed: () => context.go('/login'),
                  ),
                  SizedBox(width: 30.w),
                  Text(
                    'auth.forgot_password.title'.tr(),
                    style: AppTextStyles.font20BlackSemiBold(context),
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
                      'auth.forgot_password.description'.tr(),
                      style: AppTextStyles.font14GreyRegular(context),
                    ),
                    SizedBox(height: 24.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'auth.forgot_password.phone_number'.tr(),
                        style: AppTextStyles.font16BlackMedium(context),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Form(
                      key: _formKey,
                      child: AppTextField(
                        controller: phoneNumberController,
                        hintText: 'auth.forgot_password.phone_placeholder'.tr(),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'auth.forgot_password.validation.phone_required'.tr();
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 29.h),
                    RichText(
                      text: TextSpan(
                        text: 'auth.forgot_password.change_phone'.tr(),
                        style: AppTextStyles.font14GreyRegular(context),
                        children: [
                          TextSpan(
                            text: 'auth.forgot_password.contact_us'.tr(),
                            style: const TextStyle(
                              color: AppColors.primaryClr,
                              fontWeight: FontWeight.w400,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.go('/contact-us');
                              },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.h),
                    BlocConsumer<SendOtpCubit, SendOtpState>(
                      builder: (BuildContext context, state) {
                        final isLoading = state is Loading;
                        
                        return AppButton(
                          text: isLoading ? 'auth.forgot_password.sending'.tr() : 'auth.forgot_password.send_button'.tr(),
                          isLoading: isLoading,
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<SendOtpCubit>().sendOtp(
                                          phoneNumberController.text,
                                          context.locale.languageCode,
                                        );
                                  }
                                },
                        );
                      },
                      listener: (BuildContext context, state) {
                        if(state is Success) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            // Show OTP in snackbar for 10 seconds
                            final otpMessage = state.data?.data?.otp != null 
                                ? 'OTP: ${state.data!.data!.otp!}' 
                                : 'OTP Sent Successfully';
                            showAppSnackBar(
                              context, 
                              otpMessage,
                              duration: const Duration(seconds: 10),
                            );
                            context.go(
                              '/otp-password',
                              extra: phoneNumberController.text,
                            );
                          });
                        } else if (state is Failed) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            showAppSnackBar(context, state.error, isError: true);
                          });
                        }
                      },
                    ),
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
