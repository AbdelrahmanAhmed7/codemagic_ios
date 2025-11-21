import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/cubit/send_otp_cubit.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/send_otp_state.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/cubit/verify_otp_cubit.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/verify_otp_state.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/cubit/reset_password_cubit.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/reset_password/reset_password_state.dart';
import 'package:mediconsult/features/auth/login/repository/reset_password_repository.dart';
import 'package:mediconsult/features/auth/login/data/forget_password_models/otp_request_model.dart';
import 'package:mediconsult/features/auth/login/data/forget_password_models/verify_otp_request_model.dart';
import 'package:mediconsult/features/auth/login/data/forget_password_models/reset_password_request_model.dart';
import 'package:mediconsult/features/auth/login/data/forget_password_models/otp_response_model.dart';
import 'package:mediconsult/features/auth/login/data/forget_password_models/reset_password_response_model.dart';

class MockResetPasswordRepository extends Mock implements ResetPasswordRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    registerFallbackValue(OtpRequestModel(mobileNumber: ''));
    registerFallbackValue(VerifyOtpRequestModel(mobileNumber: '', otp: ''));
    registerFallbackValue(ResetPasswordRequestModel(mobileNumber: '', password: '', confirmPassword: ''));
  });

  late MockResetPasswordRepository repo;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repo = MockResetPasswordRepository();
  });

  blocTest<SendOtpCubit, SendOtpState>(
    'SendOtpCubit emits [loading, success] on success',
    build: () {
      when(() => repo.sendOtp(any<OtpRequestModel>(), any())).thenAnswer((_) async => ApiResult.success(
            OtpResponseModel(success: true, timestamp: 'now', message: 'ok', data: OtpData(otp: '1234')),
          ));
      return SendOtpCubit(repo);
    },
    act: (c) => c.sendOtp('010', 'ar'),
    expect: () => [
      const SendOtpState.loading(),
      isA<SendOtpState>().having((s) => s.mapOrNull(success: (v) => v), 'is success', isNotNull),
    ],
  );

  blocTest<VerifyOtpCubit, VerifyOtpState>(
    'VerifyOtpCubit emits [loading, failed] on failure',
    build: () {
      when(() => repo.verifyOtp(any<VerifyOtpRequestModel>(), any())).thenAnswer((_) async => const ApiResult.failure('invalid'));
      return VerifyOtpCubit(repo);
    },
    act: (c) => c.verifyOtp('010', '0000', 'ar'),
    expect: () => [
      const VerifyOtpState.loading(),
      isA<VerifyOtpState>().having((s) => s.mapOrNull(failed: (v) => v.error), 'is failed', isNotNull),
    ],
  );

  blocTest<ResetPasswordCubit, ResetPasswordState>(
    'ResetPasswordCubit emits [loading, success] on success',
    build: () {
      when(() => repo.resetPassword(any<ResetPasswordRequestModel>(), any())).thenAnswer((_) async => ApiResult.success(
            ResetPasswordResponseModel(success: true, timestamp: 'now', message: 'ok', data: ResetPasswordData(memberId: 1)),
          ));
      return ResetPasswordCubit(repo);
    },
    act: (c) => c.resetPassword('010', 'pw', 'pw', 'ar'),
    expect: () => [
      const ResetPasswordState.loading(),
      isA<ResetPasswordState>().having((s) => s.mapOrNull(success: (v) => v), 'is success', isNotNull),
    ],
  );
}


