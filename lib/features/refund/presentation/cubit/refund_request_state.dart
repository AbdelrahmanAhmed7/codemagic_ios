import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mediconsult/features/refund/data/refund_request_models.dart';

part 'refund_request_state.freezed.dart';

@freezed
class RefundRequestState with _$RefundRequestState {
  const factory RefundRequestState.initial() = _Initial;
  const factory RefundRequestState.loading() = Loading;
  const factory RefundRequestState.success(RefundRequestResponseData data) = Success;
  const factory RefundRequestState.failed(String message) = Failed;
}
