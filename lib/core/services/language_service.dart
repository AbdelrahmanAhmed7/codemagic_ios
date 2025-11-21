import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageKey = 'app_language';
  
  Future<String> getSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'en';
  }
  
  Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }
  
  Future<void> clearLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_languageKey);
  }
}
