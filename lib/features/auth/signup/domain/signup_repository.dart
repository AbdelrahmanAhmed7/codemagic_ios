import 'package:mediconsult/core/constants/api_result.dart';

abstract class SignupRepository {
  Future<ApiResult<void>> requestOtp({required String phoneNumber});
  Future<ApiResult<void>> verifyOtp({required String phoneNumber, required String otp});
  Future<ApiResult<void>> createAccount({
    required String fullName,
    required String phoneNumber,
    required String password,
  });
}
