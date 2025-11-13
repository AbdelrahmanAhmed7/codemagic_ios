import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/profile/presentation/cubit/change_password_state.dart';
import 'package:mediconsult/features/profile/repository/change_password_repository.dart';
import 'package:mediconsult/core/services/firebase_crashlytics_service.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordRepository _repository;

  ChangePasswordCubit(this._repository)
    : super(const ChangePasswordState.initial());

  Future<void> changePassword({
    required String lang,
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    emit(const ChangePasswordState.loading());

    final response = await _repository.changePassword(
      lang: lang,
      oldPassword: oldPassword,
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
    );

    response.when(
      success: (response) {
        emit(ChangePasswordState.success(response));
      },
      failure: (message) {
        // تسجيل فشل تغيير كلمة المرور
        FirebaseCrashlyticsService.instance.recordError(
          exception: 'Change Password Failed: $message',
          reason: 'Failed to change password',
          information: ['Language: $lang'],
        );
        
        emit(ChangePasswordState.failed(error: message));
      },
    );
  }

  void reset() {
    emit(const ChangePasswordState.initial());
  }
}