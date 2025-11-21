import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mediconsult/features/home/repository/home_repository.dart';
import 'package:mediconsult/features/home/service/home_api_service.dart';
import 'package:mediconsult/features/home/data/home_response_model.dart';
import 'package:mediconsult/core/constants/api_result.dart';

class MockHomeApiService extends Mock implements HomeApiService {}

void main() {
  late MockHomeApiService api;
  late HomeRepository repo;

  setUp(() {
    api = MockHomeApiService();
    repo = HomeRepository(api);
  });

  test('success path', () async {
    final response = HomeResponse(
      success: true,
      timestamp: 'now',
      message: 'ok',
      data: HomeData(
        memberId: 1,
        memberName: 'n',
        policyExpireDate: '2025-01-01',
        programName: 'p',
        programColor: '#FFCC33',
        notificationsCount: 0,
        approvals: const [],
      ),
    );
    when(() => api.getHomeInfo(any())).thenAnswer((_) async => response);
    final res = await repo.getHomeInfo('ar');
    res.when(success: (r) => expect(r.success, true), failure: (_) => fail('should succeed'));
  });

  test('failure path', () async {
    final response = HomeResponse(success: false, timestamp: 'now', message: 'bad', data: null);
    when(() => api.getHomeInfo(any())).thenAnswer((_) async => response);
    final res = await repo.getHomeInfo('ar');
    res.when(success: (_) => fail('should fail'), failure: (m) => expect(m, 'bad'));
  });
}


