import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mediconsult/features/policy/data/policy_categories_response.dart';

part 'get_policy_categories_state.freezed.dart';
@freezed
class GetPolicyCategoriesState with _$GetPolicyCategoriesState {
  const factory GetPolicyCategoriesState.initial() = _Initial;
  const factory GetPolicyCategoriesState.loading() = Loading;
  const factory GetPolicyCategoriesState.loaded(PolicyCategoriesResponse data) = Loaded;
  const factory GetPolicyCategoriesState.failed(String message) = Failed;
}