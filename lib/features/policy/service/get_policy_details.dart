import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:mediconsult/core/network/api_constants.dart';
import 'package:mediconsult/features/policy/data/policy_details_response.dart';

part 'get_policy_details.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class GetPolicyDetailsApiService {
  factory GetPolicyDetailsApiService(Dio dio, {String baseUrl}) = _GetPolicyDetailsApiService;

  @GET("{lang}/Policy/GetPolicyDetaliesByCateogryId")
  Future<PolicyDetailsResponse> getPolicyDetailsByCategory(
    @Path("lang") String lang,
    @Query("categoryId") int categoryId,
  );
}


