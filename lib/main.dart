import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mediconsult/core/constants/constants.dart';
import 'package:mediconsult/core/helpers/extension.dart';
import 'package:mediconsult/core/helpers/shared_pref_helper.dart';
import 'package:mediconsult/features/notifications/service/push_notifications_service.dart';
import 'package:mediconsult/firebase_options.dart';
import 'package:mediconsult/core/di/service_locator.dart';
import 'package:mediconsult/mediconsult_app.dart';
import 'package:easy_localization/easy_localization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  EasyLocalization.logger.enableBuildModes = [];
  
  // Run critical initializations in parallel (except Firebase-dependent services)
  await Future.wait<void>([
    EasyLocalization.ensureInitialized(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);
  
  // Initialize Firebase-dependent services AFTER Firebase is initialized
  await PushNotificationService.instance.initialize();
  
  // Setup service locator and check login status in parallel
  await Future.wait<void>([
    setupServiceLocator(),
    checkIfLoggedInUser(),
  ]);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
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
