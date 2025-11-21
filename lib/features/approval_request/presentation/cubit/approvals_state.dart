import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mediconsult/features/approval_request/data/approvals_models.dart';

part 'approvals_state.freezed.dart';

@freezed
class ApprovalsState with _$ApprovalsState {
  const factory ApprovalsState.initial() = _Initial;
  const factory ApprovalsState.loading() = Loading;
  const factory ApprovalsState.loaded({
    required List<ApprovalItem> approvals,
    required Pagination pagination,
    required String status,
    @Default(false) bool loadingMore,
  }) = Loaded;
  const factory ApprovalsState.failed(String message) = Failed;
}


