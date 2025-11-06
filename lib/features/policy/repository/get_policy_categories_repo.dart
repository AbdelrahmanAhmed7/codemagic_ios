import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/core/network/api_error_handler.dart';
import 'package:mediconsult/features/policy/data/policy_categories_response.dart';
import 'package:mediconsult/features/policy/service/get_policy_categories.dart';

class GetPolicyCategoriesRepository {
  final GetPolicyCategoriesApiService _categoriesApiService;
  GetPolicyCategoriesRepository(this._categoriesApiService);

  Future<ApiResult<PolicyCategoriesResponse>> getPolicyCategories(
    String lang,
  ) async {
    try {
      final response = await _categoriesApiService.getPolicyCategories(lang);

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
