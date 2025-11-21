import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mediconsult/features/network/repository/network_repository.dart';
import 'package:mediconsult/features/network/service/network_api_service.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/network/data/network_category_response_model.dart';

class MockNetworkApiService extends Mock implements NetworkApiService {}

void main() {
  late MockNetworkApiService api;
  late NetworkRepository repo;

  setUp(() {
    api = MockNetworkApiService();
    repo = NetworkRepository(api);
  });

  test('getCategories returns success when API success true', () async {
    final response = NetworkCategoryResponse(
      success: true,
      timestamp: 'now',
      message: 'ok',
      data: NetworkCategoryData(categories: const [], totalCount: 0),
    );
    when(() => api.getCategories(any())).thenAnswer((_) async => response);

    final result = await repo.getCategories('ar');
    expect(result, isA<ApiResult<NetworkCategoryResponse>>());
    result.when(
      success: (r) => expect(r.success, true),
      failure: (_) => fail('should be success'),
    );
  });

  test('getCategories returns failure when API success false', () async {
    final response = NetworkCategoryResponse(
      success: false,
      timestamp: 'now',
      message: 'bad',
      data: NetworkCategoryData(categories: const [], totalCount: 0),
    );
    when(() => api.getCategories(any())).thenAnswer((_) async => response);

    final result = await repo.getCategories('ar');
    result.when(
      success: (_) => fail('should be failure'),
      failure: (msg) => expect(msg, 'bad'),
    );
  });
}


