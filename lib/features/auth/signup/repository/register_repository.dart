import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/core/network/api_error_handler.dart';
import 'package:mediconsult/features/auth/signup/data/register_request_model.dart';
import 'package:mediconsult/features/auth/signup/data/register_response_model.dart';
import 'package:mediconsult/features/auth/signup/service/register_api_service.dart';

class RegisterRepository {
  final RegisterApiService _apiService;

  RegisterRepository(this._apiService);

  Future<ApiResult<RegisterResponseModel>> register(
    RegisterRequestModel requestModel,
    String lang,
  ) async {
    try {
      final response = await _apiService.register(lang, requestModel);

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