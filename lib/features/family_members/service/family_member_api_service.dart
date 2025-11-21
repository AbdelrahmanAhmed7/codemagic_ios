import 'package:dio/dio.dart';
import 'package:mediconsult/core/network/api_constants.dart';
import 'package:mediconsult/features/family_members/data/family_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'family_member_api_service.g.dart';
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class FamilyMemberApiService {
  factory FamilyMemberApiService(Dio dio, {String baseUrl}) = _FamilyMemberApiService;

  @GET("{lang}/FamilyMember/GetFamilyMembers")
  Future<FamilyResponse> getFamilyMembers(
    @Path("lang") String lang,
  );
}