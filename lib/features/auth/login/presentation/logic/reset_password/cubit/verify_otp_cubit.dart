import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/auth/login/data/forget_password_models/verify_otp_request_model.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/verify_otp_state.dart';
import 'package:mediconsult/features/auth/login/repository/reset_password_repository.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  final ResetPasswordRepository resetPasswordRepository;

  VerifyOtpCubit(this.resetPasswordRepository)
      : super(const VerifyOtpState.initial());

  Future<void> verifyOtp(String phoneNumber, String otpCode, String lang) async {
    emit(const VerifyOtpState.loading());
    final request = VerifyOtpRequestModel(
      mobileNumber: phoneNumber,
      otp: otpCode,
    );
    final result =
        await resetPasswordRepository.verifyOtp(request, lang);
    result.when(
      success: (data) {
        emit(VerifyOtpState.success(data));
      },
      failure: (error) {
        emit(VerifyOtpState.failed(error: error));
      },
    );
  }
}