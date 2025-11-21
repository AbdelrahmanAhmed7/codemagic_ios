import 'package:dio/dio.dart';
import 'package:mediconsult/core/network/api_constants.dart';
import 'package:mediconsult/features/auth/login/data/login_request_model.dart';
import 'package:mediconsult/features/auth/login/data/login_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'login_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class LoginApiService {
  factory LoginApiService(Dio dio, {String baseUrl}) = _LoginApiService;

  @POST("{lang}/Auth/Login")
  Future<LoginResponseModel> login(
    @Path("lang") String lang,
    @Body() LoginRequestModel body,
  );
}