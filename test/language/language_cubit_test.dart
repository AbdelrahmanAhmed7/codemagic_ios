import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mediconsult/features/profile/presentation/cubit/language_cubit.dart';
import 'package:mediconsult/features/profile/presentation/cubit/language_state.dart';
import 'package:mediconsult/core/services/language_service.dart';

class MockLanguageService extends Mock implements LanguageService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockLanguageService service;
  late LanguageCubit cubit;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPreferences.getInstance();
    service = MockLanguageService();
    cubit = LanguageCubit(service);
  });

  tearDown(() async {
    await cubit.close();
  });

  blocTest<LanguageCubit, LanguageState>(
    'loadSavedLanguage emits loaded with saved code',
    build: () {
      when(() => service.getSavedLanguage()).thenAnswer((_) async => 'ar');
      return cubit;
    },
    act: (c) => c.loadSavedLanguage(),
    expect: () => [
      const LanguageState.loading(),
      const LanguageState.loaded('ar'),
    ],
  );

  blocTest<LanguageCubit, LanguageState>(
    'changeLanguage persists and emits loaded',
    build: () {
      when(() => service.saveLanguage('ar')).thenAnswer((_) async => {});
      return cubit;
    },
    act: (c) => c.changeLanguage('ar'),
    expect: () => [
      const LanguageState.loading(),
      const LanguageState.loaded('ar'),
    ],
  );
}


