import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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

  int _secondsRemaining = 59;
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
                  SizedBox(height: 60.w),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                    ),
                    onPressed: () => context.go('/forget-password'),
                  ),
                  SizedBox(width: 30.w),
                  Text(
                    'Forgot Password',
                    style: AppTextStyles.font20BlackSemiBold(context),
                  ),
                ],
              ),
              SizedBox(height: 44.h),
              Text(
                'OTP Verification',
                style: AppTextStyles.font20BlackSemiBold(context),
              ),
              SizedBox(height: 12.h),
              Text.rich(
                TextSpan(
                  text: 'Please enter the OTP we just sent to ',
                  style: AppTextStyles.font14GreyRegular(context),
                  children: [
                    TextSpan(
                      text: widget.phoneNumber,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
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
                    errorPinTheme: PinTheme(
                      width: 70.w,
                      height: 60.h,
                      textStyle: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length != 4) {
                        return '';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                  ),
                ),
              ),

              SizedBox(height: 40.h),
              Center(
                child: Text(
                  'The verify code will expire in $_formattedTime',
                  style: AppTextStyles.font14GreyRegular(context),
                ),
              ),
              SizedBox(height: 16.h),
              BlocConsumer<ResendOtpCubit, ResendOtpState>(
                listener: (context, state) {
                  if (state is ResendFailed) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showAppSnackBar(context, state.error, isError: true);
                    });
                  }
                  if (state is ResendSuccess) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      // Show OTP in snackbar for 10 seconds
                      final otpMessage = state.data?.data?.otp != null 
                          ? 'OTP: ${state.data!.data!.otp!}' 
                          : 'Otp Resend Successfully';
                      showAppSnackBar(
                        context, 
                        otpMessage,
                        duration: const Duration(seconds: 10),
                      );
                    });
                  }
                },
                builder: (context, state) {
                  return Center(
                    child: GestureDetector(
                      onTap: _secondsRemaining == 0
                          ? () {
                              setState(() {
                                _secondsRemaining = 59;
                              });
                              _startTimer();
                              context
                                  .read<ResendOtpCubit>()
                                  .resendOtp(widget.phoneNumber, context.locale.languageCode);
                            }
                          : null,
                      child: Text(
                        'Resend Code',
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
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showAppSnackBar(context, 'OTP Verified Successfully');
                      context.go('/reset-password', extra: widget.phoneNumber);
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
                    text: isLoading ? 'Verifying...' : 'Verify',
                    isLoading: isLoading,
                    onPressed: isLoading
                        ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                final otp = _otpController.text;
                                context.read<VerifyOtpCubit>().verifyOtp(
                                  widget.phoneNumber,
                                  otp,
                                  context.locale.languageCode,
                                );
                              }
                            },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
