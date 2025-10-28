import 'package:freezed_annotation/freezed_annotation.dart';

part 'language_state.freezed.dart';

@freezed
class LanguageState with _$LanguageState {
  const factory LanguageState.initial() = Initial;
  const factory LanguageState.loading() = Loading;
  const factory LanguageState.loaded(String languageCode) = Loaded;
  const factory LanguageState.error(String message) = Error;
}
