import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/utils/app_button.dart';
import 'package:mediconsult/features/auth/signup/presentation/logic/signup_cubit.dart';
import 'package:mediconsult/features/auth/signup/presentation/logic/signup_state.dart';
import 'package:mediconsult/features/auth/signup/presentation/widgets/app_text_field.dart';
import 'package:mediconsult/shared/widgets/app_snack_bar.dart';
import 'package:mediconsult/shared/widgets/form_fields/form_fields.dart';
import 'package:easy_localization/easy_localization.dart';

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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 60.w),
                Center(
                  child: Image.asset(
                    'assets/logo/Logo.png',
                    width: 140.w,
                    height: 50.h,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 40.h),
                Text(
                  'auth.signup.title'.tr(),
                  style: AppTextStyles.font20BlackSemiBold(context),
                ),
                SizedBox(height: 12.h),
                Text(
                  'auth.signup.subtitle'.tr(),
                  style: AppTextStyles.font14GreyRegular(context),
                ),
                SizedBox(height: 24.h),

                Text.rich(
                  TextSpan(
                    text: 'auth.signup.card_id'.tr(),
                    style: AppTextStyles.font14BlackMedium(context),
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
                  controller: cardController,
                  hintText: 'auth.signup.card_id_placeholder'.tr(),
                  prefixImagePath: AppAssets.cardIcon,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'auth.signup.validation.card_id_required'.tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                Text.rich(
                  TextSpan(
                    text: 'auth.signup.national_id'.tr(),
                    style: AppTextStyles.font14BlackMedium(context),
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
                  hintText: 'auth.signup.national_id_placeholder'.tr(),
                  prefixImagePath: AppAssets.idIcon,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'auth.signup.validation.national_id_required'.tr();
                    }
                    if (value.length != 14 ||
                        !RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'auth.signup.validation.national_id_invalid'.tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                Text.rich(
                  TextSpan(
                    text: 'auth.signup.phone_number'.tr(),
                    style: AppTextStyles.font14BlackMedium(context),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red, fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                EgyptianPhoneField(
                  controller: phoneController,
                  phoneRequiredKey: 'auth.signup.validation.phone_required',
                  phoneInvalidKey: 'auth.signup.validation.phone_invalid',
                  hintText: 'auth.signup.validation.phone_hint'.tr(),
                ),
                SizedBox(height: 16.h),

                Text.rich(
                  TextSpan(
                    text: 'auth.signup.password'.tr(),
                    style: AppTextStyles.font14BlackMedium(context),
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
                  hintText: 'auth.signup.password_placeholder'.tr(),
                  isPassword: true,
                  prefixImagePath: AppAssets.passwordIcon,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'auth.signup.validation.password_required'.tr();
                    } else if (value.length < 8) {
                      return 'auth.signup.validation.password_length'.tr();
                    }

                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                Text.rich(
                  TextSpan(
                    text: 'auth.signup.confirm_password'.tr(),
                    style: AppTextStyles.font14BlackMedium(context),
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
                  hintText: 'auth.signup.confirm_password_placeholder'.tr(),
                  isPassword: true,
                  prefixImagePath: AppAssets.passwordIcon,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'auth.signup.validation.confirm_password_required'.tr();
                    } else if (value != passwordController.text) {
                      return 'auth.signup.validation.passwords_not_match'.tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),

                BlocConsumer<SignupCubit, SignupState>(
                  listener: (context, state) {
                    if (state is Success) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showAppSnackBar(context, 'auth.signup.registration_successful'.tr());
                        context.go('/home');
                      });
                    } else if (state is Failed) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showAppSnackBar(context, state.error, isError: true);
                      });
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is Loading;

                    return AppButton(
                      text: isLoading ? 'auth.signup.registering'.tr() : 'auth.signup.register_button'.tr(),
                      isLoading: isLoading,
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                // Remove leading 0 if exists, then add it back for backend
                                final phoneNumber = EgyptianPhoneField.formatPhoneNumber(
                                  phoneController.text.trim(),
                                );
                                context.read<SignupCubit>().signup(
                                  cardController.text.trim(),
                                  nationalController.text.trim(),
                                  phoneNumber,
                                  passwordController.text.trim(),
                                  confirmPasswordController.text.trim(),
                                  context.locale.languageCode,
                                );
                              }
                            },
                    );
                  },
                ),

                SizedBox(height: 31.h),

                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: Text.rich(
                      TextSpan(
                        text: 'auth.signup.already_have_account'.tr(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[700],
                        ),
                        children: [
                          TextSpan(
                            text: 'auth.signup.login'.tr(),
                            style: TextStyle(
                              color: AppColors.primaryClr,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.push('/login');
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
      ),
    );
  }
}
