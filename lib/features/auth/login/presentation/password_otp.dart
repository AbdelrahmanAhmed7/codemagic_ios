import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/widgets/auth_base_layout.dart';
import 'package:pinput/pinput.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/utils/app_button.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/cubit/resend_otp_cubit.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/cubit/verify_otp_cubit.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/resend_otp_state.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/verify_otp_state.dart';
import 'package:mediconsult/shared/widgets/app_snack_bar.dart';

class PasswordOtpScreen extends StatefulWidget {
  final String phoneNumber;

  const PasswordOtpScreen({super.key, required this.phoneNumber});

  @override
  State<PasswordOtpScreen> createState() => _PasswordOtpScreenState();
}

class _PasswordOtpScreenState extends State<PasswordOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  int _secondsRemaining = 180;
  late final _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Stream.periodic(const Duration(seconds: 1), (x) => x).listen((_) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
Widget build(BuildContext context) {
  return AuthBaseLayout(
    title: 'auth.forgot_password.otp_title'.tr(),
    onBack: () => context.go('/forget-password'),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'auth.forgot_password.otp_instruction'.tr(namedArgs: {'phone': widget.phoneNumber}),
          style: AppTextStyles.font14GreyRegular(context),
        ),
        SizedBox(height: 33.h),
        Form(
          key: _formKey,
          child: Center(
            child: Pinput(
              controller: _otpController,
              length: 4,
              defaultPinTheme: PinTheme(
                width: 70.w,
                height: 60.h,
                textStyle: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              focusedPinTheme: PinTheme(
                width: 70.w,
                height: 60.h,
                textStyle: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryClr),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              validator: (value) =>
                  value == null || value.length != 4 ? '' : null,
              keyboardType: TextInputType.number,
              showCursor: true,
            ),
          ),
        ),
        SizedBox(height: 40.h),
        Center(
          child: Text(
            'auth.forgot_password.otp_expire_in'.tr(namedArgs: {'time': _formattedTime}),
            style: AppTextStyles.font14GreyRegular(context),
          ),
        ),
        SizedBox(height: 16.h),
        BlocConsumer<ResendOtpCubit, ResendOtpState>(
          listener: (context, state) {
            if (state is ResendFailed) {
              showAppSnackBar(context, state.error, isError: true);
            } else if (state is ResendSuccess) {
              showAppSnackBar(
                context,
                'auth.forgot_password.otp_resend_success'.tr(),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: GestureDetector(
                onTap: _secondsRemaining == 0
                    ? () {
                        setState(() {
                          _secondsRemaining = 180;
                        });
                        _startTimer();
                        context
                            .read<ResendOtpCubit>()
                            .resendOtp(widget.phoneNumber,
                                context.locale.languageCode);
                      }
                    : null,
                child: Text(
                  'auth.forgot_password.resend_code'.tr(),
                  style: TextStyle(
                    color: _secondsRemaining == 0
                        ? AppColors.primaryClr
                        : Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 41.h),
        BlocConsumer<VerifyOtpCubit, VerifyOtpState>(
          listener: (context, state) {
            if (state is Success) {
              showAppSnackBar(context, 'auth.forgot_password.otp_verified'.tr());
              context.push('/reset-password', extra: widget.phoneNumber);
            } else if (state is Failed) {
              showAppSnackBar(context, state.error, isError: true);
            }
          },
          builder: (context, state) {
            final isLoading = state is Loading;
            return AppButton(
              text: isLoading ? 'auth.forgot_password.verifying'.tr() : 'auth.forgot_password.verify'.tr(),
              isLoading: isLoading,
              onPressed: isLoading
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        context.read<VerifyOtpCubit>().verifyOtp(
                              widget.phoneNumber,
                              _otpController.text,
                              context.locale.languageCode,
                            );
                      }
                    },
            );
          },
        ),
      ],
    ),
  );
}
}
