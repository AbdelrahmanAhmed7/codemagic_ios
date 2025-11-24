import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mediconsult/core/services/language_service.dart';

void main() {
  late LanguageService languageService;

  setUp(() {
    languageService = LanguageService();
  });

  group('LanguageService', () {
    test('getSavedLanguage returns default "en" when no language is saved', () async {
      SharedPreferences.setMockInitialValues({});
      
      final result = await languageService.getSavedLanguage();
      
      expect(result, equals('en'));
    });

    test('getSavedLanguage returns saved language when it exists', () async {
      SharedPreferences.setMockInitialValues({'locale': 'ar'});
      
      final result = await languageService.getSavedLanguage();
      
      expect(result, equals('ar'));
    });

    test('saveLanguage saves language code correctly', () async {
      SharedPreferences.setMockInitialValues({});
      
      await languageService.saveLanguage('ar');
      
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('locale'), equals('ar'));
    });

    test('saveLanguage overwrites existing language', () async {
      SharedPreferences.setMockInitialValues({'locale': 'en'});
      
      await languageService.saveLanguage('ar');
      
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('locale'), equals('ar'));
    });

    test('clearLanguage removes saved language', () async {
      SharedPreferences.setMockInitialValues({'locale': 'ar'});
      
      await languageService.clearLanguage();
      
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('locale'), isNull);
    });

    test('clearLanguage works when no language is saved', () async {
      SharedPreferences.setMockInitialValues({});
      
      await languageService.clearLanguage();
      
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('locale'), isNull);
    });

    test('language service uses correct key "locale"', () async {
      SharedPreferences.setMockInitialValues({});
      
      await languageService.saveLanguage('ar');
      
      final prefs = await SharedPreferences.getInstance();
      // Verify it uses 'locale' key (same as EasyLocalization)
      expect(prefs.containsKey('locale'), isTrue);
      expect(prefs.containsKey('app_language'), isFalse);
    });

    test('supports both Arabic and English', () async {
      SharedPreferences.setMockInitialValues({});
      
      // Test Arabic
      await languageService.saveLanguage('ar');
      var result = await languageService.getSavedLanguage();
      expect(result, equals('ar'));
      
      // Test English
      await languageService.saveLanguage('en');
      result = await languageService.getSavedLanguage();
      expect(result, equals('en'));
    });
  });
}
