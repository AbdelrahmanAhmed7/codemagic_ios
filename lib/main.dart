import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mediconsult/firebase_options.dart';
import 'package:mediconsult/mediconsult_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MediConsultApp());
}