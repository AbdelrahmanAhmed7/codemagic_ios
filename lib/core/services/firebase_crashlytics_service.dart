import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// خدمة Firebase Crashlytics لتتبع الأخطاء والتحطم في التطبيق
class FirebaseCrashlyticsService {
  static final FirebaseCrashlyticsService _instance = FirebaseCrashlyticsService._internal();
  static FirebaseCrashlyticsService get instance => _instance;
  
  FirebaseCrashlyticsService._internal();
  
  late final FirebaseCrashlytics _crashlytics;
  
  /// تهيئة Firebase Crashlytics
  Future<void> initialize() async {
    try {
      _crashlytics = FirebaseCrashlytics.instance;
      
      // تعطيل Crashlytics في وضع التطوير
      if (kDebugMode) {
        await _crashlytics.setCrashlyticsCollectionEnabled(false);
        print('🔧 Crashlytics disabled in debug mode');
      } else {
        await _crashlytics.setCrashlyticsCollectionEnabled(true);
        print('✅ Crashlytics enabled in release mode');
      }
      
      // تسجيل الأخطاء غير المعالجة في Flutter
      FlutterError.onError = (FlutterErrorDetails details) {
        _crashlytics.recordFlutterFatalError(details);
      };
      
      // تسجيل الأخطاء غير المعالجة في Dart
      PlatformDispatcher.instance.onError = (error, stack) {
        _crashlytics.recordError(error, stack, fatal: true);
        return true;
      };
      
      if (kDebugMode) {
        print('✅ Firebase Crashlytics initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to initialize Firebase Crashlytics: $e');
      }
    }
  }
  
  /// تسجيل خطأ غير قاتل
  Future<void> recordError({
    required dynamic exception,
    StackTrace? stackTrace,
    String? reason,
    Iterable<Object> information = const [],
    bool fatal = false,
  }) async {
    try {
      await _crashlytics.recordError(
        exception,
        stackTrace,
        reason: reason,
        information: information,
        fatal: fatal,
      );
      
      if (kDebugMode) {
        print('🐛 Crashlytics Error Recorded: $exception');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to record error to Crashlytics: $e');
      }
    }
  }
  
  /// تسجيل رسالة مخصصة
  Future<void> log(String message) async {
    try {
      await _crashlytics.log(message);
      
      if (kDebugMode) {
        print('📝 Crashlytics Log: $message');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to log message to Crashlytics: $e');
      }
    }
  }
  
  /// تعيين معرف المستخدم
  Future<void> setUserId(String userId) async {
    try {
      await _crashlytics.setUserIdentifier(userId);
      
      if (kDebugMode) {
        print('👤 Crashlytics User ID set: $userId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to set Crashlytics user ID: $e');
      }
    }
  }
  
  /// تعيين مفتاح مخصص
  Future<void> setCustomKey({
    required String key,
    required Object value,
  }) async {
    try {
      await _crashlytics.setCustomKey(key, value);
      
      if (kDebugMode) {
        print('🔑 Crashlytics Custom Key set: $key = $value');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to set Crashlytics custom key: $e');
      }
    }
  }
  
  /// تسجيل خطأ في API
  Future<void> recordApiError({
    required String endpoint,
    required int statusCode,
    required String errorMessage,
    String? requestData,
  }) async {
    await setCustomKey(key: 'api_endpoint', value: endpoint);
    await setCustomKey(key: 'api_status_code', value: statusCode);
    await setCustomKey(key: 'api_request_data', value: requestData ?? 'N/A');
    
    await recordError(
      exception: 'API Error: $errorMessage',
      reason: 'API call failed for $endpoint',
      information: [
        'Endpoint: $endpoint',
        'Status Code: $statusCode',
        'Error: $errorMessage',
        if (requestData != null) 'Request Data: $requestData',
      ],
    );
  }
  
  /// تسجيل خطأ في المصادقة
  Future<void> recordAuthError({
    required String authMethod,
    required String errorMessage,
    String? userId,
  }) async {
    await setCustomKey(key: 'auth_method', value: authMethod);
    if (userId != null) {
      await setCustomKey(key: 'attempted_user_id', value: userId);
    }
    
    await recordError(
      exception: 'Authentication Error: $errorMessage',
      reason: 'Authentication failed using $authMethod',
      information: [
        'Auth Method: $authMethod',
        'Error: $errorMessage',
        if (userId != null) 'User ID: $userId',
      ],
    );
  }
  
  /// تسجيل خطأ في الشبكة
  Future<void> recordNetworkError({
    required String errorType,
    required String errorMessage,
    String? url,
  }) async {
    await setCustomKey(key: 'network_error_type', value: errorType);
    if (url != null) {
      await setCustomKey(key: 'network_url', value: url);
    }
    
    await recordError(
      exception: 'Network Error: $errorMessage',
      reason: 'Network operation failed',
      information: [
        'Error Type: $errorType',
        'Error: $errorMessage',
        if (url != null) 'URL: $url',
      ],
    );
  }
  
  /// تسجيل خطأ في الـ Cache
  Future<void> recordCacheError({
    required String cacheType,
    required String operation,
    required String errorMessage,
  }) async {
    await setCustomKey(key: 'cache_type', value: cacheType);
    await setCustomKey(key: 'cache_operation', value: operation);
    
    await recordError(
      exception: 'Cache Error: $errorMessage',
      reason: 'Cache operation failed',
      information: [
        'Cache Type: $cacheType',
        'Operation: $operation',
        'Error: $errorMessage',
      ],
    );
  }
  
  /// تسجيل خطأ في الـ Navigation
  Future<void> recordNavigationError({
    required String route,
    required String errorMessage,
    Map<String, dynamic>? routeParams,
  }) async {
    await setCustomKey(key: 'navigation_route', value: route);
    if (routeParams != null) {
      await setCustomKey(key: 'route_params', value: routeParams.toString());
    }
    
    await recordError(
      exception: 'Navigation Error: $errorMessage',
      reason: 'Navigation failed',
      information: [
        'Route: $route',
        'Error: $errorMessage',
        if (routeParams != null) 'Params: $routeParams',
      ],
    );
  }
  
  /// تسجيل خطأ في الـ State Management
  Future<void> recordStateError({
    required String cubitName,
    required String stateName,
    required String errorMessage,
    Map<String, dynamic>? stateData,
  }) async {
    await setCustomKey(key: 'cubit_name', value: cubitName);
    await setCustomKey(key: 'state_name', value: stateName);
    if (stateData != null) {
      await setCustomKey(key: 'state_data', value: stateData.toString());
    }
    
    await recordError(
      exception: 'State Management Error: $errorMessage',
      reason: 'State transition failed',
      information: [
        'Cubit: $cubitName',
        'State: $stateName',
        'Error: $errorMessage',
        if (stateData != null) 'State Data: $stateData',
      ],
    );
  }
  
  /// تسجيل معلومات الجلسة
  Future<void> setSessionInfo({
    required String userId,
    required String appVersion,
    required String language,
  }) async {
    await Future.wait([
      setUserId(userId),
      setCustomKey(key: 'app_version', value: appVersion),
      setCustomKey(key: 'user_language', value: language),
      setCustomKey(key: 'session_start', value: DateTime.now().toIso8601String()),
    ]);
  }
  
  /// مسح بيانات المستخدم (عند تسجيل الخروج)
  Future<void> clearUserData() async {
    try {
      await _crashlytics.setUserIdentifier('');
      
      if (kDebugMode) {
        print('🧹 Crashlytics user data cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to clear Crashlytics user data: $e');
      }
    }
  }
  
  /// إرسال تقرير تحطم تجريبي (للاختبار فقط)
  Future<void> testCrash() async {
    if (kDebugMode) {
      print('🧪 Test crash triggered (Debug mode - not sent to Crashlytics)');
      return;
    }
    
    _crashlytics.crash();
  }
  
  /// إرسال خطأ اختبار لتفعيل Crashlytics Console
  Future<void> sendTestError() async {
    try {
      await recordError(
        exception: 'Test Error for Crashlytics Setup',
        reason: 'Testing Crashlytics integration',
        information: [
          'Platform: ${kIsWeb ? 'Web' : 'Mobile'}',
          'Debug Mode: $kDebugMode',
          'Timestamp: ${DateTime.now().toIso8601String()}',
        ],
      );
      
      await log('Crashlytics test error sent successfully');
      
      if (kDebugMode) {
        print('✅ Test error sent to Crashlytics');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to send test error: $e');
      }
    }
  }
}
