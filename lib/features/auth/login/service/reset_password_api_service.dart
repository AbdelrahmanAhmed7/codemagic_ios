import 'package:dio/dio.dart';
import 'package:mediconsult/features/auth/login/data/forget_password_models/otp_request_model.dart';
import 'package:mediconsult/features/auth/login/data/forget_password_models/otp_response_model.dart';
import 'package:mediconsult/features/auth/login/data/forget_password_models/resend_otp_request_model.dart';
import 'package:mediconsult/features/auth/login/data/forget_password_models/resend_otp_response_model.dart';
import 'package:mediconsult/features/auth/login/data/forget_password_models/reset_password_request_model.dart';
import 'package:mediconsult/features/auth/login/data/forget_password_models/reset_password_response_model.dart';
import 'package:mediconsult/features/auth/login/data/forget_password_models/verify_otp_request_model.dart';
import 'package:mediconsult/features/auth/login/data/forget_password_models/verify_otp_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:mediconsult/core/network/api_constants.dart';

part 'reset_password_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ResetPasswordApiService {
  factory ResetPasswordApiService(Dio dio, {String baseUrl}) = _ResetPasswordApiService;

  @POST("{lang}/ForgetPassword/SendOtp")
  Future<OtpResponseModel> sendOtp(
    @Path("lang") String lang,
    @Body() OtpRequestModel body,
  );

  @POST("{lang}/ForgetPassword/VerifyOtp")
  Future<VerifyOtpResponse> verifyOtp(
    @Path("lang") String lang,
    @Body() VerifyOtpRequestModel body,
  );

  @POST("{lang}/ForgetPassword/ResetPassword")
  Future<ResetPasswordResponseModel> resetPassword(
    @Path("lang") String lang,
    @Body() ResetPasswordRequestModel body,
  );

  @POST("{lang}/ForgetPassword/ResendOtp")
  Future<ResendOtpResponseModel> resendOtp(
    @Path("lang") String lang,
    @Body() ResendOtpRequestModel body,
  );  
}
