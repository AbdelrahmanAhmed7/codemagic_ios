import 'package:flutter/foundation.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/core/di/service_locator.dart';
import 'package:mediconsult/features/notifications/service/push_notifications_service.dart';
import 'package:mediconsult/features/profile/repository/profile_repository.dart';

/// Service to handle Firebase token updates
class FirebaseTokenService {
  FirebaseTokenService._();
  static final FirebaseTokenService instance = FirebaseTokenService._();

  /// Send Firebase token to backend
  /// Call this after successful login or signup
  Future<bool> sendTokenToBackend(String lang) async {
    try {
      // Get current FCM token
      final token = PushNotificationService.instance.currentToken;
      
      if (token == null || token.isEmpty) {
        debugPrint('⚠️ No FCM token available to send');
        return false;
      }

      debugPrint('📤 Sending FCM token to backend: $token');

      // Get profile repository from service locator
      final profileRepository = sl<ProfileRepository>();
      
      // Send token to backend
      final result = await profileRepository.updateFirebaseToken(lang, token);
      
      if (result is Success) {
        debugPrint('✅ FCM token sent successfully');
        return true;
      } else if (result is Failure) {
        debugPrint('❌ Failed to send FCM token: ${(result as Failure).message}');
        return false;
      }
      
      return false;
    } catch (e) {
      debugPrint('❌ Error sending FCM token: $e');
      return false;
    }
  }

  /// Listen to token refresh and send to backend
  void listenToTokenRefresh(String lang) {
    PushNotificationService.instance.onTokenRefresh.listen((token) {
      debugPrint('🔄 FCM token refreshed, sending to backend...');
      sendTokenToBackend(lang);
    });
  }
}
