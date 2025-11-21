import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/auth/login/data/forget_password_models/otp_request_model.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/send_otp_state.dart';
import 'package:mediconsult/features/auth/login/repository/reset_password_repository.dart';

class SendOtpCubit extends Cubit<SendOtpState> {
  final ResetPasswordRepository resetPasswordRepository;

  SendOtpCubit(this.resetPasswordRepository)
      : super(const SendOtpState.initial());

  Future<void> sendOtp(String phoneNumber, String lang) async {
    emit(const SendOtpState.loading());
    final request = OtpRequestModel(mobileNumber: phoneNumber);
    final result =
        await resetPasswordRepository.sendOtp(request, lang);
    result.when(
      success: (data) {
        emit(SendOtpState.success(data));
      },
      failure: (error) {
        emit(SendOtpState.failed(error: error));
      },
    );
  }
}