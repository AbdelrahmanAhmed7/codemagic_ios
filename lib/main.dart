import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mediconsult/core/constants/constants.dart';
import 'package:mediconsult/core/helpers/extension.dart';
import 'package:mediconsult/core/helpers/shared_pref_helper.dart';
import 'package:mediconsult/firebase_options.dart';
import 'package:mediconsult/core/di/service_locator.dart';
import 'package:mediconsult/mediconsult_app.dart';
import 'package:easy_localization/easy_localization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupServiceLocator();
  await checkIfLoggedInUser();

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
  String? userToken =
      await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
  if (!userToken.isNullOrEmpty()) {
    isLoggedInUser = true;
  } else {
    isLoggedInUser = false;
  }
}