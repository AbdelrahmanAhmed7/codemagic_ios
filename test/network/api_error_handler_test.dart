import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mediconsult/core/network/api_error_handler.dart';

void main() {
  group('ErrorHandler.handle', () {
    test('timeout maps to friendly message', () {
      final err = DioException(requestOptions: RequestOptions(path: '/'), type: DioExceptionType.connectionTimeout);
      expect(ErrorHandler.handle(err), contains('timeout'));
    });

    test('401 unauthorized', () {
      final err = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badResponse,
        response: Response(requestOptions: RequestOptions(path: '/'), statusCode: 401),
      );
      expect(ErrorHandler.handle(err), contains('Unauthorized'));
    });

    test('500 internal', () {
      final err = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badResponse,
        response: Response(requestOptions: RequestOptions(path: '/'), statusCode: 500),
      );
      expect(ErrorHandler.handle(err), contains('Internal'));
    });

    test('SocketException -> no internet', () {
      final err = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.unknown,
        error: const SocketException('no internet'),
      );
      expect(ErrorHandler.handle(err), contains('No internet'));
    });
  });
}


