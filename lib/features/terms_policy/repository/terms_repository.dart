import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/core/network/api_error_handler.dart';
import 'package:mediconsult/features/terms_policy/data/terms_privacy_response.dart';
import 'package:mediconsult/features/terms_policy/service/terms_api_service.dart';

class TermsRepository {
  final TermsApiService _apiService;
  TermsRepository(this._apiService);

  Future<ApiResult<TermsPrivacyResponse>> getTerms(String lang) async {
    try {
      final res = await _apiService.getTerms(lang);
      return res.success ? ApiResult.success(res) : ApiResult.failure(res.message);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  Future<ApiResult<TermsPrivacyResponse>> getPrivacy(String lang) async {
    try {
      final res = await _apiService.getPrivacy(lang);
      return res.success ? ApiResult.success(res) : ApiResult.failure(res.message);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}


