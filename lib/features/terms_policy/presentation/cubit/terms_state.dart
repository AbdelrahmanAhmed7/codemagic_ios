import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mediconsult/features/terms_policy/data/terms_privacy_response.dart';

part 'terms_state.freezed.dart';

@freezed
class TermsState with _$TermsState {
  const factory TermsState.initial() = _Initial;
  const factory TermsState.loading() = _Loading;
  const factory TermsState.loaded(TermsPrivacyResponse data) = _Loaded;
  const factory TermsState.failed(String message) = _Failed;
}


