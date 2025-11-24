import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  // Use the same key as EasyLocalization to ensure consistency
  static const String _languageKey = 'locale';
  
  Future<String> getSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    // EasyLocalization saves locale as language code only
    return prefs.getString(_languageKey) ?? 'en';
  }
  
  Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    // Save in the same format as EasyLocalization
    await prefs.setString(_languageKey, languageCode);
  }
  
  Future<void> clearLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_languageKey);
  }
}
