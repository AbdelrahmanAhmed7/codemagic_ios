import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mediconsult/features/family_members/data/family_response_model.dart';

part 'family_members_state.freezed.dart';
@freezed
class FamilyMembersState with _$FamilyMembersState {
  const factory FamilyMembersState.initial() = _Initial;
  const factory FamilyMembersState.loading() = Loading;
  const factory FamilyMembersState.loaded(FamilyResponse model) = Loaded;
  const factory FamilyMembersState.failed(String message) = Failed;
}