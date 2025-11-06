import 'package:dio/dio.dart';
import 'package:mediconsult/core/network/api_constants.dart';
import 'package:mediconsult/features/policy/data/policy_categories_response.dart';
import 'package:retrofit/retrofit.dart';

part 'get_policy_categories.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class GetPolicyCategoriesApiService {
  factory GetPolicyCategoriesApiService(Dio dio, {String baseUrl}) = _GetPolicyCategoriesApiService;

  /// Get all policy categories
  @GET("{lang}/Policy/GetPolicyCategories")
  Future<PolicyCategoriesResponse> getPolicyCategories(
    @Path("lang") String lang,
  );
}