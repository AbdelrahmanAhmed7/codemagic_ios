import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/core/network/api_error_handler.dart';
import 'package:mediconsult/features/policy/data/policy_details_response.dart';
import 'package:mediconsult/features/policy/service/get_policy_details.dart';

class GetPolicyDetailsRepository {
  final GetPolicyDetailsApiService _service;
  GetPolicyDetailsRepository(this._service);

  Future<ApiResult<PolicyDetailsResponse>> getByCategoryId(
    String lang,
    int categoryId,
  ) async {
    try {
      final response = await _service.getPolicyDetailsByCategory(lang, categoryId);
      if (response.success == true) {
        return ApiResult.success(response);
      } else {
        // معالجة رسائل الخطأ من الخادم
        return ApiResult.failure(response.message);
      }
    } catch (error) {
      final errorMessage = ErrorHandler.handle(error);
      return ApiResult.failure(errorMessage);
    }
  }
}





