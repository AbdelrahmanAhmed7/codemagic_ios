import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:mediconsult/core/network/api_constants.dart';
import 'package:mediconsult/features/terms_policy/data/terms_privacy_response.dart';

part 'terms_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class TermsApiService {
  factory TermsApiService(Dio dio, {String baseUrl}) = _TermsApiService;

  @GET('/{lang}/PrivacyAndTerms/GetTermsAndConditions')
  Future<TermsPrivacyResponse> getTerms(
    @Path('lang') String lang,
  );

  @GET('/{lang}/PrivacyAndTerms/GetPrivacyPolicy')
  Future<TermsPrivacyResponse> getPrivacy(
    @Path('lang') String lang,
  );
}


