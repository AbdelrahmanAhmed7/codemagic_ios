import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mediconsult/core/cache/home_cache_service.dart';
import 'package:mediconsult/features/home/data/home_response_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPreferences.getInstance();
  });

  test('cache and read home data', () async {
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

    await HomeCacheService.cacheHomeData(response);
    final cached = await HomeCacheService.getCachedHomeData();
    expect(cached?.success, true);
  });

  test('clear cache removes data', () async {
    await HomeCacheService.clearCache();
    final cached = await HomeCacheService.getCachedHomeData();
    expect(cached, isNull);
  });
}


