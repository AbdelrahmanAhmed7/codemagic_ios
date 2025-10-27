import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mediconsult/features/approval_request/data/approvals_models.dart';

part 'refunds_state.freezed.dart';

@freezed
class RefundsState with _$RefundsState {
  const factory RefundsState.initial() = _Initial;
  const factory RefundsState.loading() = Loading;
  const factory RefundsState.loaded({
    required List<RefundItem> refunds,
    required Pagination pagination,
    required String status,
    @Default(false) bool loadingMore,
  }) = Loaded;
  const factory RefundsState.failed(String message) = Failed;
}

class RefundItem {
  final int id;
  final String? providerLogo;
  final String providerName;
  final String requestNumber;
  final String date;
  final String time;
  final String status; // Pending/Approved/Rejected
  final String statusChar; // P/A/R
  final String? notes;

  RefundItem({
    required this.id,
    this.providerLogo,
    required this.providerName,
    required this.requestNumber,
    required this.date,
    required this.time,
    required this.status,
    required this.statusChar,
    this.notes,
  });
}