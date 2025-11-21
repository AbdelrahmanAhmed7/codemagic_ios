import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  SharedPrefHelper._();

  // ---------------------- SharedPreferences ----------------------

  static Future<void> setData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (kDebugMode)
      debugPrint("SharedPrefHelper : setData key=$key value=$value");
    if (value is String)
      await prefs.setString(key, value);
    else if (value is int)
      await prefs.setInt(key, value);
    else if (value is bool)
      await prefs.setBool(key, value);
    else if (value is double)
      await prefs.setDouble(key, value);
  }

  static Future<String> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (kDebugMode) debugPrint("SharedPrefHelper : getString key=$key");
    return prefs.getString(key) ?? '';
  }

  static Future<bool> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    debugPrint("SharedPrefHelper : getBool key=$key");
    return prefs.getBool(key) ?? false;
  }

  static Future<void> removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ---------------------- Flutter Secure Storage ----------------------

  static const _secureStorage = FlutterSecureStorage();

  static Future<void> setSecuredString(String key, String value) async {
    if (kDebugMode) debugPrint("SecureStorage : set $key = $value");
    await _secureStorage.write(key: key, value: value);
  }

  static Future<String> getSecuredString(String key) async {
    if (kDebugMode) debugPrint("SecureStorage : get $key");
    return await _secureStorage.read(key: key) ?? '';
  }

  static Future<void> clearAllSecuredData() async {
    if (kDebugMode) ("SecureStorage : cleared all");
    await _secureStorage.deleteAll();
  }
}
