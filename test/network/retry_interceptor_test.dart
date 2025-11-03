import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mediconsult/core/network/retry_interceptor.dart';
import 'package:mediconsult/core/network/connectivity_service.dart';

class MockConnectivity extends Mock implements ConnectivityService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Dio dio;
  late MockConnectivity connectivity;

  setUp(() {
    dio = Dio();
    connectivity = MockConnectivity();
    dio.interceptors.add(RetryInterceptor(connectivityService: connectivity, maxRetries: 1, baseDelay: const Duration(milliseconds: 1)));
  });

  test('does not retry when offline', () async {
    when(() => connectivity.checkConnectivity()).thenAnswer((_) async => false);
    dio.httpClientAdapter = _ErroringAdapter();
    try {
      await dio.get('https://example.com');
      fail('should throw');
    } catch (e) {
      // ok
    }
  });
}

class _ErroringAdapter implements HttpClientAdapter {
  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<List<int>>? requestStream, Future<void>? cancelFuture) async {
    throw DioException(requestOptions: options, type: DioExceptionType.connectionTimeout);
  }
}


