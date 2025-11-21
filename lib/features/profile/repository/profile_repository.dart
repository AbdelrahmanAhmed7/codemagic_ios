import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/core/network/api_error_handler.dart';
import 'package:mediconsult/features/profile/data/personal_info_response.dart';
import 'package:mediconsult/features/profile/service/profile_api_service.dart';

class ProfileRepository {
  final ProfileApiService _apiService;
  ProfileRepository(this._apiService);

  Future<ApiResult<PersonalInfoResponse>> getPersonalInfo(String lang) async {
    try {
      final response = await _apiService.getPersonalInfo(lang);
      if (response.success == true) {
        return ApiResult.success(response);
      }
      return ApiResult.failure(response.message);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<bool>> updateFirebaseToken(String lang, String token) async {
    try {
      final response = await _apiService.updateFirebaseToken(
        lang,
        {'token': token},
      );
      if (response.response.statusCode != null && 
          response.response.statusCode! >= 200 && 
          response.response.statusCode! < 300) {
        return const ApiResult.success(true);
      }
      return const ApiResult.failure('Failed to update Firebase token');
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
