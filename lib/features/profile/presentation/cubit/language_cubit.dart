import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/services/language_service.dart';
import 'package:mediconsult/features/profile/presentation/cubit/language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  final LanguageService _languageService;
  
  LanguageCubit(this._languageService) : super(const LanguageState.initial());
  
  Future<void> loadSavedLanguage() async {
    try {
      emit(const LanguageState.loading());
      final languageCode = await _languageService.getSavedLanguage();
      emit(LanguageState.loaded(languageCode));
    } catch (e) {
      emit(LanguageState.error(e.toString()));
    }
  }
  
  Future<void> changeLanguage(String languageCode) async {
    try {
      emit(const LanguageState.loading());
      await _languageService.saveLanguage(languageCode);
      emit(LanguageState.loaded(languageCode));
    } catch (e) {
      emit(LanguageState.error(e.toString()));
    }
  }
  
  String getCurrentLanguage() {
    return state.maybeWhen(
      loaded: (languageCode) => languageCode,
      orElse: () => 'en',
    );
  }
}
