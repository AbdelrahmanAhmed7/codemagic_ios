import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/utils/app_button.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/login_cubit.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/login_state.dart';
import 'package:mediconsult/features/auth/signup/presentation/widgets/app_text_field.dart';
import 'package:mediconsult/shared/widgets/app_snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';

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
  void initState() {
    super.initState();
    _clearFields(); 
  }

  void _clearFields() {
    cardOrPhoneController.clear();
    passwordController.clear();
  }

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
                Center(
                  child: Image.asset(
                    AppAssets.logo,
                    width: 172.w,
                    height: 38.h,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 43.h),

                Text(
                  'auth.login.title'.tr(),
                  style: AppTextStyles.font20BlackSemiBold(context),
                ),
                SizedBox(height: 12.h),
                Text(
                  'auth.login.subtitle'.tr(),
                  style: AppTextStyles.font16GreyRegular(context),
                ),
                SizedBox(height: 40.h),

                Text(
                  'auth.login.card_id'.tr(),
                  style: AppTextStyles.font16BlackMedium(context),
                ),
                SizedBox(height: 8.h),
                AppTextField(
                  controller: cardOrPhoneController,
                  hintText: 'auth.login.card_id_placeholder'.tr(),
                  prefixImagePath: AppAssets.cardIcon,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'auth.login.validation.card_id_required'.tr();
                    }
                    if (!value.startsWith('20')) {
                      return 'auth.login.validation.card_id_start'.tr();
                    }
                    if (value.length != 7) {
                      return 'auth.login.validation.card_id_length'.tr();
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'auth.login.validation.card_id_numbers'.tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                Text(
                  'auth.login.password'.tr(),
                  style: AppTextStyles.font16BlackMedium(context),
                ),
                SizedBox(height: 8.h),
                AppTextField(
                  controller: passwordController,
                  hintText: 'auth.login.password_placeholder'.tr(),
                  isPassword: true,
                  prefixImagePath: AppAssets.passwordIcon,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'auth.login.validation.password_required'.tr();
                    } else if (value.length < 8) {
                      return 'auth.login.validation.password_length'.tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.h),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.push('/forget-password');
                    },
                    child: Text(
                      'auth.login.forgot_password'.tr(),
                      style: TextStyle(
                        color: AppColors.primaryClr,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 28.h),

                BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state is Success) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showAppSnackBar(
                          context,
                          'auth.login.login_successful'.tr(),
                        );
                        _clearFields();
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
                      text: isLoading
                          ? 'auth.login.logging_in'.tr()
                          : 'auth.login.login_button'.tr(),
                      isLoading: isLoading,
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<LoginCubit>().login(
                                  cardOrPhoneController.text.trim(),
                                  passwordController.text.trim(),
                                  context.locale.languageCode,
                                );
                              }
                            },
                    );
                  },
                ),
                SizedBox(height: 31.h),

                Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'auth.login.dont_have_account'.tr(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey[700],
                      ),
                      children: [
                        TextSpan(
                          text: 'auth.login.register'.tr(),
                          style: TextStyle(
                            color: AppColors.primaryClr,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.push('/signup');
                            },
                        ),
                      ],
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
