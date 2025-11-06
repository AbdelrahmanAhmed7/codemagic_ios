import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:mediconsult/core/network/api_constants.dart';
import 'package:mediconsult/features/support/data/contacts_response_model.dart';
import 'package:mediconsult/features/support/data/faq_response_model.dart';

part 'support_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class SupportApiService {
  factory SupportApiService(Dio dio, {String baseUrl}) = _SupportApiService;

  /// Contacts endpoint: /{lang}/ContactUs/Get
  @GET('/{lang}/ContactUs/Get')
  Future<ContactsResponse> getContacts(@Path('lang') String lang);

  @GET('/{lang}/FAQ/GetFAQs')
  Future<FAQResponse> getFaqs(@Path('lang') String lang);
}
