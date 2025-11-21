import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mediconsult/features/profile/data/personal_info_response.dart';

part 'personal_info_state.freezed.dart';

@freezed
class PersonalInfoState with _$PersonalInfoState {
  const factory PersonalInfoState.initial() = _Initial;
  const factory PersonalInfoState.loading() = Loading;
  const factory PersonalInfoState.loaded(PersonalInfoResponse data) = Loaded;
  const factory PersonalInfoState.failed(String message) = Failed;
}