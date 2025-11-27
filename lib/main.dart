import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mediconsult/core/constants/constants.dart';
import 'package:mediconsult/core/di/service_locator.dart';
import 'package:mediconsult/core/helpers/extension.dart';
import 'package:mediconsult/core/helpers/shared_pref_helper.dart';
import 'package:mediconsult/core/network/connectivity_service.dart';
import 'package:mediconsult/core/services/firebase_crashlytics_service.dart';
import 'package:mediconsult/core/services/firebase_token_service.dart';
import 'package:mediconsult/features/notifications/service/push_notifications_service.dart';
import 'package:mediconsult/firebase_options.dart';
import 'package:mediconsult/mediconsult_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  EasyLocalization.logger.enableBuildModes = [];

  await _clearDataOnReinstall();

  await Future.wait<void>([
    EasyLocalization.ensureInitialized(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);

  // تهيئة خدمات Firebase
  await FirebaseCrashlyticsService.instance.initialize();

  // إرسال رسالة اختبار لتفعيل Crashlytics Console
  await FirebaseCrashlyticsService.instance.log(
    'App started successfully - ${DateTime.now()}',
  );

  // إرسال خطأ اختبار لتفعيل Dashboard (فقط في Release mode)
  if (!kDebugMode) {
    await FirebaseCrashlyticsService.instance.sendTestError();
  }

  await ConnectivityService.instance.initialize();

  await PushNotificationService.instance.initialize();

  await Future.wait<void>([
    setupServiceLocator(),
    checkIfLoggedInUser(),
    checkOnboardingStatus(),
  ]);

  // Send Firebase token if user is logged in
  if (isLoggedInUser) {
    // Get saved language or use default 'ar'
    final savedLocale = await SharedPrefHelper.getString('locale');
    final lang = (savedLocale.isEmpty) ? 'ar' : savedLocale;

    // Send token in background (non-blocking)
    FirebaseTokenService.instance.sendTokenToBackend(lang);

    // Listen to token refresh and send to backend
    FirebaseTokenService.instance.listenToTokenRefresh(lang);
  }

  // Get saved language for EasyLocalization
  final savedLocale = await SharedPrefHelper.getString('locale');
  final startLocale = savedLocale.isNotEmpty
      ? Locale(savedLocale)
      : const Locale('en');

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: startLocale, // Use saved locale
      useOnlyLangCode: true,
      saveLocale: true,
      child: const MediConsultApp(),
    ),
  );
}

checkIfLoggedInUser() async {
  String? userToken = await SharedPrefHelper.getSecuredString(
    SharedPrefKeys.userToken,
  );
  if (!userToken.isNullOrEmpty()) {
    isLoggedInUser = true;
  } else {
    isLoggedInUser = false;
  }
}

checkOnboardingStatus() async {
  final hasSeen = await SharedPrefHelper.getBool(
    SharedPrefKeys.hasSeenOnboarding,
  );
  shouldShowOnboarding = !hasSeen;
  if (kDebugMode) {
    debugPrint(
      'Onboarding Status: hasSeen=$hasSeen, shouldShow=$shouldShowOnboarding',
    );
  }
}

Future<void> _clearDataOnReinstall() async {
  final prefs = await SharedPreferences.getInstance();
  const key = 'app_installed_before';

  final hasInstalledBefore = prefs.getBool(key) ?? false;

  if (!hasInstalledBefore) {
    await SharedPrefHelper.clearAllSecuredData();
    await SharedPrefHelper.clearAllData();

    await prefs.setBool(key, true);

    if (kDebugMode) {
      debugPrint('First launch after install - cleared all cached data');
    }
  }
}
