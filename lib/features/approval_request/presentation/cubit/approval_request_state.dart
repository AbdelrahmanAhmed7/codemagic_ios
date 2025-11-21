import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mediconsult/features/approval_request/data/approval_request_models.dart';

part 'approval_request_state.freezed.dart';

@freezed
class ApprovalRequestState with _$ApprovalRequestState {
  const factory ApprovalRequestState.initial() = _Initial;
  const factory ApprovalRequestState.loading() = Loading;
  const factory ApprovalRequestState.success(ApprovalRequestData data) = Success;
  const factory ApprovalRequestState.failed(String message) = Failed;
}
