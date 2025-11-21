import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/login_cubit.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/login_state.dart';
import 'package:mediconsult/features/auth/login/repository/login_repository.dart';
import 'package:mediconsult/features/auth/login/data/login_request_model.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/auth/login/data/login_response_model.dart';
import 'package:mediconsult/features/auth/login/data/login_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(LoginRequestModel(cardNo: '', password: ''));

    const MethodChannel secureStorageChannel =
    MethodChannel('plugins.it_nomads.com/flutter_secure_storage');

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      secureStorageChannel,
          (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'read':
            return null;
          case 'write':
            return true;
          case 'delete':
            return true;
          case 'deleteAll':
            return true;
          case 'readAll':
            return <String, String>{};
          default:
            return null;
        }
      },
    );
  });

  late MockLoginRepository repository;
  late LoginCubit cubit;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = MockLoginRepository();
    cubit = LoginCubit(repository);
  });

  tearDown(() {
    cubit.close();
  });

  blocTest<LoginCubit, LoginState>(
    'emits [loading, success] when login succeeds',
    build: () {
      when(() => repository.login(any<LoginRequestModel>(), any()))
          .thenAnswer((_) async => ApiResult.success(
        LoginResponseModel(
          success: true,
          timestamp: 'now',
          message: 'ok',
          data: LoginDataModel(
            token: 't',
            memberId: 1,
            memberName: 'name',
            phoneNumber: '010',
            nationalId: '123',
          ),
        ),
      ));
      return cubit;
    },
    act: (c) => c.login('123', 'pwd', 'ar'),
    wait: const Duration(milliseconds: 50),
    expect: () => [
      const LoginState.loading(),
      isA<LoginState>().having((s) => s.mapOrNull(success: (v) => v), 'is success', isNotNull),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'emits [loading, failed] when login fails',
    build: () {
      when(() => repository.login(any<LoginRequestModel>(), any()))
          .thenAnswer((_) async => const ApiResult.failure('error'));
      return cubit;
    },
    act: (c) => c.login('123', 'bad', 'ar'),
    wait: const Duration(milliseconds: 50),
    expect: () => [
      const LoginState.loading(),
      isA<LoginState>().having((s) => s.mapOrNull(failed: (v) => v.error), 'is failed', isNotNull),
    ],
  );
}
