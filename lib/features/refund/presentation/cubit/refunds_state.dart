import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mediconsult/features/refund/data/refund_list_models.dart';

part 'refunds_state.freezed.dart';

@freezed
class RefundsState with _$RefundsState {
  const factory RefundsState.initial() = _Initial;
  const factory RefundsState.loading() = Loading;
  const factory RefundsState.loaded({
    required List<RefundItem> refunds,
    required PaginationInfo pagination,
    required String status,
    @Default(false) bool loadingMore,
  }) = Loaded;
  const factory RefundsState.failed(String message) = Failed;
}