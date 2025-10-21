import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/auth/login/data/forget_password_models/resend_otp_request_model.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/resend_otp_state.dart';
import 'package:mediconsult/features/auth/login/repository/reset_password_repository.dart';

class ResendOtpCubit extends Cubit<ResendOtpState> {
  final ResetPasswordRepository resetPasswordRepository;

  ResendOtpCubit(this.resetPasswordRepository)
      : super(const ResendOtpState.resendinitial());

  Future<void> resendOtp(String phoneNumber, String lang) async {
    emit(const ResendOtpState.resendloading());
    final request = ResendOtpRequestModel(mobileNumber: phoneNumber);
    final result =
        await resetPasswordRepository.resendOtp(request, lang);
    result.when(
      success: (data) {
        emit(ResendOtpState.resendsuccess(data));
      },
      failure: (error) {
        emit(ResendOtpState.resendfailed(error: error));
      },
    );
  }
}