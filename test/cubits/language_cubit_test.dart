import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mediconsult/features/profile/presentation/cubit/language_cubit.dart';
import 'package:mediconsult/features/profile/presentation/cubit/language_state.dart';
import 'package:mediconsult/core/services/language_service.dart';

class MockLanguageService extends Mock implements LanguageService {}

void main() {
  late MockLanguageService mockLanguageService;
  late LanguageCubit cubit;

  setUp(() {
    mockLanguageService = MockLanguageService();
    cubit = LanguageCubit(mockLanguageService);
  });

  tearDown(() {
    cubit.close();
  });

  group('LanguageCubit', () {
    test('initial state is LanguageState.initial()', () {
      expect(cubit.state, equals(const LanguageState.initial()));
    });

    blocTest<LanguageCubit, LanguageState>(
      'emits [loading, loaded] when loadSavedLanguage succeeds with Arabic',
      build: () {
        when(() => mockLanguageService.getSavedLanguage())
            .thenAnswer((_) async => 'ar');
        return cubit;
      },
      act: (cubit) => cubit.loadSavedLanguage(),
      expect: () => [
        const LanguageState.loading(),
        const LanguageState.loaded('ar'),
      ],
      verify: (_) {
        verify(() => mockLanguageService.getSavedLanguage()).called(1);
      },
    );

    blocTest<LanguageCubit, LanguageState>(
      'emits [loading, loaded] when loadSavedLanguage succeeds with English',
      build: () {
        when(() => mockLanguageService.getSavedLanguage())
            .thenAnswer((_) async => 'en');
        return cubit;
      },
      act: (cubit) => cubit.loadSavedLanguage(),
      expect: () => [
        const LanguageState.loading(),
        const LanguageState.loaded('en'),
      ],
    );

    blocTest<LanguageCubit, LanguageState>(
      'emits [loading, error] when loadSavedLanguage fails',
      build: () {
        when(() => mockLanguageService.getSavedLanguage())
            .thenThrow(Exception('Failed to load language'));
        return cubit;
      },
      act: (cubit) => cubit.loadSavedLanguage(),
      expect: () => [
        const LanguageState.loading(),
        isA<LanguageState>().having(
          (s) => s.mapOrNull(error: (e) => e.message),
          'error message',
          contains('Exception'),
        ),
      ],
    );

    blocTest<LanguageCubit, LanguageState>(
      'emits [loading, loaded] when changeLanguage succeeds',
      build: () {
        when(() => mockLanguageService.saveLanguage(any()))
            .thenAnswer((_) async => {});
        return cubit;
      },
      act: (cubit) => cubit.changeLanguage('ar'),
      expect: () => [
        const LanguageState.loading(),
        const LanguageState.loaded('ar'),
      ],
      verify: (_) {
        verify(() => mockLanguageService.saveLanguage('ar')).called(1);
      },
    );

    blocTest<LanguageCubit, LanguageState>(
      'emits [loading, error] when changeLanguage fails',
      build: () {
        when(() => mockLanguageService.saveLanguage(any()))
            .thenThrow(Exception('Failed to save language'));
        return cubit;
      },
      act: (cubit) => cubit.changeLanguage('en'),
      expect: () => [
        const LanguageState.loading(),
        isA<LanguageState>().having(
          (s) => s.mapOrNull(error: (e) => e.message),
          'error message',
          contains('Exception'),
        ),
      ],
    );

    test('getCurrentLanguage returns correct language code when loaded', () {
      when(() => mockLanguageService.getSavedLanguage())
          .thenAnswer((_) async => 'ar');
      
      cubit.loadSavedLanguage();
      
      // Wait for state to update
      expectLater(
        cubit.stream,
        emitsInOrder([
          const LanguageState.loading(),
          const LanguageState.loaded('ar'),
        ]),
      );
    });

    test('getCurrentLanguage returns "en" when state is not loaded', () {
      expect(cubit.getCurrentLanguage(), equals('en'));
    });
  });
}
