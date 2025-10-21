import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/core/network/api_error_handler.dart';
import 'package:mediconsult/features/auth/login/data/login_request_model.dart';
import 'package:mediconsult/features/auth/login/data/login_response_model.dart';
import 'package:mediconsult/features/auth/login/service/login_api_service.dart';

class LoginRepository {
  final LoginApiService _apiService;

  LoginRepository(this._apiService);

  Future<ApiResult<LoginResponseModel>> login(
    LoginRequestModel request,
    String lang,
  ) async {
    try {
      final response = await _apiService.login(lang, request);

      if (response.success == true && response.data != null) {
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