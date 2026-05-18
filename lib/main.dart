import 'dart:async';

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

  unawaited(
    FirebaseCrashlyticsService.instance.log(
      'App started successfully - ${DateTime.now()}',
    ),
  );

  await Future.wait<void>([
    setupServiceLocator(),
    checkIfLoggedInUser(),
    checkOnboardingStatus(),
  ]);

  final savedLocale = await SharedPrefHelper.getString('locale');
  final startLocale = savedLocale.isNotEmpty
      ? Locale(savedLocale)
      : const Locale('en');

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: startLocale,
      useOnlyLangCode: true,
      saveLocale: true,
      child: const MediConsultApp(),
    ),
  );

  // Non-critical services — must not block first frame (native splash removal).
  unawaited(_initializePostLaunchServices(savedLocale));
}

Future<void> _initializePostLaunchServices(String savedLocale) async {
  if (!kDebugMode) {
    unawaited(FirebaseCrashlyticsService.instance.sendTestError());
  }

  unawaited(ConnectivityService.instance.initialize());

  final pushReady = await PushNotificationService.instance
      .initialize()
      .timeout(const Duration(seconds: 15), onTimeout: () => false);

  if (!pushReady || !isLoggedInUser) return;

  final lang = savedLocale.isEmpty ? 'ar' : savedLocale;
  unawaited(FirebaseTokenService.instance.sendTokenToBackend(lang));
  FirebaseTokenService.instance.listenToTokenRefresh(lang);
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
    try {
      await SharedPrefHelper.clearAllSecuredData().timeout(
        const Duration(seconds: 5),
      );
    } catch (_) {
      // Keychain can hang on iOS if access groups mismatch; don't block launch.
    }
    await SharedPrefHelper.clearAllData();

    await prefs.setBool(key, true);

    if (kDebugMode) {
      debugPrint('First launch after install - cleared all cached data');
    }
  }
}
