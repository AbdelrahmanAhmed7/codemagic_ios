import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mediconsult/features/support/data/faq_response_model.dart';

part 'faq_state.freezed.dart';

@freezed
class FaqState with _$FaqState {
  const factory FaqState.initial() = _Initial;
  const factory FaqState.loading() = Loading;
  const factory FaqState.loaded(FAQResponse data) = Loaded;
  const factory FaqState.failed(String message) = Failed;
}