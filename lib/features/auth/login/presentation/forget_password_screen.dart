import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/utils/app_button.dart';
import 'package:mediconsult/core/widgets/auth_base_layout.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/cubit/send_otp_cubit.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/send_otp_state.dart';
import 'package:mediconsult/shared/widgets/app_snack_bar.dart';
import 'package:mediconsult/shared/widgets/form_fields/form_fields.dart';
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
    return AuthBaseLayout(
      title: 'auth.forgot_password.title'.tr(),
      onBack: () => context.go('/login'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  alignment: context.locale.languageCode == 'ar'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Text(
                    'auth.forgot_password.phone_number'.tr(),
                    style: AppTextStyles.font16BlackMedium(context),
                    textAlign: context.locale.languageCode == 'ar'
                        ? TextAlign.right
                        : TextAlign.left,
                  ),
                ),

                SizedBox(height: 8.h),
                Form(
                  key: _formKey,
                  child: EgyptianPhoneField(
                    controller: phoneNumberController,
                    phoneRequiredKey: 'auth.forgot_password.validation.phone_required',
                    phoneInvalidKey: 'auth.forgot_password.validation.phone_invalid',
                    hintText: 'auth.forgot_password.validation.phone_hint'.tr(),
                  ),
                ),
                SizedBox(height: 29.h),
                RichText(
                  textAlign: TextAlign.center,
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
                          ..onTap = () => context.push('/contact-us'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                BlocConsumer<SendOtpCubit, SendOtpState>(
                  builder: (context, state) {
                    final isLoading = state is Loading;
                    return AppButton(
                      text: isLoading
                          ? 'auth.forgot_password.sending'.tr()
                          : 'auth.forgot_password.send_button'.tr(),
                      isLoading: isLoading,
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                final phoneNumber = EgyptianPhoneField.formatPhoneNumber(
                                  phoneNumberController.text,
                                );
                                context.read<SendOtpCubit>().sendOtp(
                                  phoneNumber,
                                  context.locale.languageCode,
                                );
                              }
                            },
                    );
                  },
                  listener: (context, state) {
                    if (state is Success) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showAppSnackBar(
                          context,
                          'auth.forgot_password.otp_sent_success'.tr(),
                        );
                        final phoneNumber = EgyptianPhoneField.formatPhoneNumber(
                          phoneNumberController.text,
                        );
                        context.push(
                          '/otp-password',
                          extra: phoneNumber,
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
    );
  }
}
