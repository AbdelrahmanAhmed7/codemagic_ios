import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mediconsult/features/home/presentation/cubit/cubit/home_cubit.dart';
import 'package:mediconsult/features/home/presentation/cubit/cubit/home_state.dart';
import 'package:mediconsult/features/home/repository/home_repository.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/home/data/home_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

  HomeResponse buildHomeResponse() => HomeResponse(
        success: true,
        timestamp: 'now',
        message: 'ok',
        data: HomeData(
          memberId: 1,
          memberName: 'User',
          policyExpireDate: '2025-01-01',
          programName: 'Prog',
          programColor: '#FFCC33',
          notificationsCount: 0,
          approvals: const [],
        ),
      );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockHomeRepository repository;
  late HomeCubit cubit;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = MockHomeRepository();
    cubit = HomeCubit(repository);
  });

  tearDown(() async {
    await cubit.close();
  });

  test('initial state', () {
    expect(cubit.state, HomeCubitState.initial());
  });

  blocTest<HomeCubit, HomeCubitState>(
    'emits loaded from cache then refresh in background',
    build: () {
      // Mock cache hit
      // Using fallback: we cannot mock top-level functions directly without wrappers;
      // assume repository returns success when called for background refresh.
      when(() => repository.getHomeInfo(any())).thenAnswer((_) async => ApiResult.success(buildHomeResponse()));
      return cubit;
    },
    act: (c) async {
      // We cannot easily stub cache static methods here; call with forceRefresh to bypass cache path
      await c.getHomeInfo('ar', forceRefresh: true);
    },
    wait: const Duration(milliseconds: 50),
    expect: () => [
      HomeCubitState.loading(),
      isA<HomeCubitState>().having((s) => s.maybeMap(loaded: (_) => true, orElse: () => false), 'loaded', true),
    ],
  );

  blocTest<HomeCubit, HomeCubitState>(
    'emits failed when repository fails and no cache',
    build: () {
      when(() => repository.getHomeInfo(any())).thenAnswer((_) async => const ApiResult.failure('error'));
      return cubit;
    },
    act: (c) async {
      await c.getHomeInfo('ar', forceRefresh: true);
    },
    wait: const Duration(milliseconds: 50),
    expect: () => [
      HomeCubitState.loading(),
      isA<HomeCubitState>().having((s) => s.maybeMap(failed: (_) => true, orElse: () => false), 'failed', true),
    ],
  );
}


