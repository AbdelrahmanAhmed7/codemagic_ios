import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mediconsult/core/helpers/shared_pref_helper.dart';
import 'package:mediconsult/core/constants/constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:mediconsult/core/network/retry_interceptor.dart';
import 'package:mediconsult/core/network/connectivity_service.dart';

class DioFactory {
  DioFactory._();
  static Dio? _dio;

  static Future<Dio> getDio() async {
    if (_dio != null) return _dio!;

    const timeout = Duration(seconds: 30);
    _dio = Dio()
      ..options.connectTimeout = timeout
      ..options.receiveTimeout = timeout;

    await _addHeaders();
    _addInterceptors();
    return _dio!;
  }

  static Future<void> _addHeaders() async {
    final token = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userToken,
    );
    _dio?.options.headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static void setTokenIntoHeaderAfterLogin(String token) {
    _dio?.options.headers['Authorization'] = 'Bearer $token';
  }

  static void _addInterceptors() {
    // Add retry interceptor first (so it catches errors)
    _dio?.interceptors.add(
      RetryInterceptor(
        connectivityService: ConnectivityService.instance,
        maxRetries: 3,
        baseDelay: const Duration(seconds: 2),
      ),
    );

    // Add logger interceptor
    if (kDebugMode) {
      _dio?.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      );
    }
  }
}