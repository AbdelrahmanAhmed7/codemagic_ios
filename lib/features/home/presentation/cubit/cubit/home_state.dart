import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mediconsult/features/home/data/home_response_model.dart';

part 'home_state.freezed.dart';
@freezed
class HomeCubitState with _$HomeCubitState {
  const factory HomeCubitState.initial() = _Initial;

  const factory HomeCubitState.loading() = Loading;

  const factory HomeCubitState.loaded(HomeResponse model) = Loaded;

  const factory HomeCubitState.failed(String message) = Failed;
}
