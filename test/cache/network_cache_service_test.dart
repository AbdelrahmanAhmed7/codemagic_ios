import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mediconsult/core/cache/network_cache_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPreferences.getInstance();
  });

  test('cache and read network categories data', () async {
    await NetworkCacheService.cacheNetworkCategoriesData({'ok': true});
    final cached = await NetworkCacheService.getCachedNetworkCategoriesData();
    expect(cached, isNotNull);
  });

  test('cache and read governments data', () async {
    await NetworkCacheService.cacheNetworkGovernmentsData({'list': []});
    final cached = await NetworkCacheService.getCachedNetworkGovernmentsData();
    expect(cached, isNotNull);
  });

  test('cache and read cities data by gov id', () async {
    await NetworkCacheService.cacheNetworkCitiesData(1, {'cities': []});
    final cached = await NetworkCacheService.getCachedNetworkCitiesData(1);
    expect(cached, isNotNull);
  });
}


