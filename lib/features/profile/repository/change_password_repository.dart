import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/core/network/api_error_handler.dart';
import 'package:mediconsult/features/profile/data/change_password_request.dart';
import 'package:mediconsult/features/profile/data/change_password_response.dart';
import 'package:mediconsult/features/profile/service/profile_api_service.dart';

class ChangePasswordRepository {
  final ProfileApiService _apiService;

  ChangePasswordRepository(this._apiService);

  Future<ApiResult<ChangePasswordResponse>> changePassword({
    required String lang,
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      final request = ChangePasswordRequest(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
      );

      final response = await _apiService.changePassword(lang, request);

      if (response.success == true) {
        return ApiResult.success(response);
      } else {
        return ApiResult.failure(response.message);
      }
    } catch (error) {
      final errorMessage = ErrorHandler.handle(error);
      return ApiResult.failure(errorMessage);
    }
  }
}
