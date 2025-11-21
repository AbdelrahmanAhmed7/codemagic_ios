import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mediconsult/features/auth/signup/presentation/logic/signup_cubit.dart';
import 'package:mediconsult/features/auth/signup/presentation/logic/signup_state.dart';
import 'package:mediconsult/features/auth/signup/repository/register_repository.dart';
import 'package:mediconsult/features/auth/signup/data/register_request_model.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/auth/signup/data/register_response_model.dart';
import 'package:mediconsult/features/auth/signup/data/register_data_model.dart';

class MockRegisterRepository extends Mock implements RegisterRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(
      RegisterRequestModel(
        cardNo: '',
        nationalId: '',
        phoneNumber: '',
        password: '',
        confirmPassword: '',
      ),
    );

    const MethodChannel secureStorageChannel =
    MethodChannel('plugins.it_nomads.com/flutter_secure_storage');

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      secureStorageChannel,
          (MethodCall call) async {
        return null;
      },
    );
  });

  late MockRegisterRepository repo;
  late SignupCubit cubit;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repo = MockRegisterRepository();
    cubit = SignupCubit(repo);
  });

  tearDown(() async {
    await cubit.close();
  });

  blocTest<SignupCubit, SignupState>(
    'emits [loading, success] on successful signup',
    build: () {
      when(() => repo.register(any<RegisterRequestModel>(), any())).thenAnswer(
            (_) async => ApiResult.success(
          RegisterResponseModel(
            success: true,
            timestamp: 'now',
            message: 'ok',
            data: RegisterDataModel(
              token: 't',
              memberId: 1,
              memberName: 'n',
              phoneNumber: '010',
              nationalId: '1',
            ),
          ),
        ),
      );
      return cubit;
    },
    act: (c) => c.signup('c', 'n', 'p', 'pw', 'pw', 'ar'),
    wait: const Duration(milliseconds: 50),
    expect: () => [
      const SignupState.loading(),
      isA<SignupState>()
          .having((s) => s.mapOrNull(success: (v) => v), 'is success', isNotNull),
    ],
  );

  blocTest<SignupCubit, SignupState>(
    'emits [loading, failed] on signup failure',
    build: () {
      when(() => repo.register(any<RegisterRequestModel>(), any()))
          .thenAnswer((_) async => const ApiResult.failure('err'));
      return cubit;
    },
    act: (c) => c.signup('c', 'n', 'p', 'pw', 'pw', 'ar'),
    wait: const Duration(milliseconds: 50),
    expect: () => [
      const SignupState.loading(),
      isA<SignupState>()
          .having((s) => s.mapOrNull(failed: (v) => v.error), 'is failed', isNotNull),
    ],
  );
}
