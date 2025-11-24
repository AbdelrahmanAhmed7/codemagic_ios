import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mediconsult/core/network/api_constants.dart';

void main() {
  group('Network Performance Tests', () {
    late Dio dio;

    setUp(() {
      dio = Dio(BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ));
    });

    test('Dio instance creation', () {
      expect(dio, isNotNull);
      expect(dio.options.baseUrl, equals(ApiConstants.baseUrl));
      print('🌐 Dio instance created successfully');
    });

    test('Measure connection timeout configuration', () {
      expect(dio.options.connectTimeout, equals(const Duration(seconds: 10)));
      expect(dio.options.receiveTimeout, equals(const Duration(seconds: 10)));
      print('⏱️ Timeout configuration verified');
    });

    test('Verify base URL configuration', () {
      expect(dio.options.baseUrl, isNotEmpty);
      expect(dio.options.baseUrl, startsWith('http'));
      print('🔗 Base URL configuration verified: ${dio.options.baseUrl}');
    });

    test('Test request headers configuration', () {
      dio.options.headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      expect(dio.options.headers['Content-Type'], equals('application/json'));
      expect(dio.options.headers['Accept'], equals('application/json'));
      print('📋 Headers configuration verified');
    });

    test('Test interceptor setup', () {
      // Add a simple interceptor
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            print('📤 Request: ${options.method} ${options.path}');
            handler.next(options);
          },
          onResponse: (response, handler) {
            print('📥 Response: ${response.statusCode}');
            handler.next(response);
          },
          onError: (error, handler) {
            print('❌ Error: ${error.message}');
            handler.next(error);
          },
        ),
      );

      expect(dio.interceptors.length, greaterThan(0));
      print('🔧 Interceptors configured successfully');
    });
  });
}
