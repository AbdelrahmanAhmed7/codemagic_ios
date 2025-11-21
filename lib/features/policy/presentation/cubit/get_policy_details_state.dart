import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mediconsult/features/policy/data/policy_details_response.dart';

part 'get_policy_details_state.freezed.dart';

@freezed
class GetPolicyDetailsState with _$GetPolicyDetailsState {
  const factory GetPolicyDetailsState.initial() = _Initial;
  const factory GetPolicyDetailsState.loading() = Loading;
  const factory GetPolicyDetailsState.loaded(PolicyDetailsResponse data) = Loaded;
  const factory GetPolicyDetailsState.failed(String message) = Failed;
}





