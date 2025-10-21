import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/auth/login/data/forget_password_models/reset_password_request_model.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/reset_password_state.dart';
import 'package:mediconsult/features/auth/login/repository/reset_password_repository.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(this._resetPasswordRepository) : super(ResetPasswordState.initial());

  final ResetPasswordRepository _resetPasswordRepository;

  Future<void> resetPassword(String phoneNumber, String newPassword, String confirmedPassword, String lang) async {
    emit(const ResetPasswordState.loading());

    final request = ResetPasswordRequestModel(
      mobileNumber: phoneNumber,
      password: newPassword,
      confirmPassword: confirmedPassword,
    );
    final result = await _resetPasswordRepository.resetPassword(request, lang);
    result.when(
      success: (data) {
        emit(ResetPasswordState.success(data));
      },
      failure: (error) {
        emit(ResetPasswordState.failed(error: error));
      },
    );
  }
}