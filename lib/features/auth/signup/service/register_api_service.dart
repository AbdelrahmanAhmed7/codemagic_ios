import 'package:dio/dio.dart';
import 'package:mediconsult/core/network/api_constants.dart';
import 'package:mediconsult/features/auth/signup/data/register_request_model.dart';
import 'package:mediconsult/features/auth/signup/data/register_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'register_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class RegisterApiService {
  factory RegisterApiService(Dio dio, {String baseUrl}) = _RegisterApiService;

  @POST("{lang}/Auth/Register")
  Future<RegisterResponseModel> register(
    @Path("lang") String lang,
    @Body() RegisterRequestModel body,
  );
}