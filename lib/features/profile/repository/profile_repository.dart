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
}


