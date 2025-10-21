import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/core/network/api_error_handler.dart';
import 'package:mediconsult/features/auth/login/data/forget_password_models/otp_request_model.dart';
import 'package:mediconsult/features/auth/login/data/forget_password_models/otp_response_model.dart';
import 'package:mediconsult/features/auth/login/data/forget_password_models/resend_otp_request_model.dart';
import 'package:mediconsult/features/auth/login/data/forget_password_models/resend_otp_response_model.dart';
import 'package:mediconsult/features/auth/login/data/forget_password_models/reset_password_request_model.dart';
import 'package:mediconsult/features/auth/login/data/forget_password_models/reset_password_response_model.dart';
import 'package:mediconsult/features/auth/login/data/forget_password_models/verify_otp_request_model.dart';
import 'package:mediconsult/features/auth/login/data/forget_password_models/verify_otp_response.dart';
import 'package:mediconsult/features/auth/login/service/reset_password_api_service.dart';

class ResetPasswordRepository {
  final ResetPasswordApiService _apiService;

  ResetPasswordRepository(this._apiService);

  //  Send OTP
  Future<ApiResult<OtpResponseModel>> sendOtp(
    OtpRequestModel request,
    String lang,
  ) async {
    try {
      final response = await _apiService.sendOtp(lang, request);

      if (response.success == true && response.data != null) {
        return ApiResult.success(response);
      } else {
        return ApiResult.failure(response.message);
      }
    } catch (error) {
      final errorMessage = ErrorHandler.handle(error);
      return ApiResult.failure(errorMessage);
    }
  }

  // Verify OTP
  Future<ApiResult<VerifyOtpResponse>> verifyOtp(
    VerifyOtpRequestModel request,
    String lang,
  ) async {
    try {
      final response = await _apiService.verifyOtp(lang, request);

      if (response.success == true && response.data != null) {
        return ApiResult.success(response);
      } else {
        return ApiResult.failure(response.message);
      }
    } catch (error) {
      final errorMessage = ErrorHandler.handle(error);
      return ApiResult.failure(errorMessage);
    }
  }

  // Reset Password
  Future<ApiResult<ResetPasswordResponseModel>> resetPassword(
    ResetPasswordRequestModel request,
    String lang,
  ) async {
    try {
      final response = await _apiService.resetPassword(lang, request);

      if (response.success == true && response.data != null) {
        return ApiResult.success(response);
      } else {
        return ApiResult.failure(response.message);
      }
    } catch (error) {
      final errorMessage = ErrorHandler.handle(error);
      return ApiResult.failure(errorMessage);
    }
  }

  // Resend OTP
  Future<ApiResult<ResendOtpResponseModel>> resendOtp(
    ResendOtpRequestModel request,
    String lang,
  ) async {
    try {
      final response = await _apiService.resendOtp(lang, request);

      if (response.success == true && response.data != null) {
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
