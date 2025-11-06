import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:mediconsult/core/network/api_constants.dart';
import 'package:mediconsult/features/profile/data/personal_info_response.dart';

part 'profile_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ProfileApiService {
  factory ProfileApiService(Dio dio, {String baseUrl}) = _ProfileApiService;

  @GET('/{lang}/Profile/GetPersonalInfo')
  Future<PersonalInfoResponse> getPersonalInfo(
    @Path('lang') String lang,
  );
}


