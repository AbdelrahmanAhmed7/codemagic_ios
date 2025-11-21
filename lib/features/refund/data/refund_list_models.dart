import 'package:json_annotation/json_annotation.dart';

part 'refund_list_models.g.dart';

@JsonSerializable(explicitToJson: true)
class RefundListResponse {
  final bool success;
  final String? timestamp;
  final String? message;
  final RefundListData? data;

  RefundListResponse({
    required this.success,
    this.timestamp,
    this.message,
    this.data,
  });

  factory RefundListResponse.fromJson(Map<String, dynamic> json) =>
      _$RefundListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RefundListResponseToJson(this);
}

@JsonSerializable()
class RefundListData {
  final List<RefundItem> refunds;
  final PaginationInfo pagination;
  final FilterInfo filter;

  RefundListData({
    required this.refunds,
    required this.pagination,
    required this.filter,
  });

  factory RefundListData.fromJson(Map<String, dynamic> json) =>
      _$RefundListDataFromJson(json);
  Map<String, dynamic> toJson() => _$RefundListDataToJson(this);
}

@JsonSerializable()
class RefundItem {
  final int id;
  final String providerLogo;
  final String providerName;
  final String approvalNumber;
  final bool isRequest;
  final String date;
  final String time;
  final String status;
  final String statusChar;
  final String notes;
  final double? totalAmount;
  final String refundDate;
  final int? refundReasonId;
  final int? refundTypeId;
  final String attachmentsFolder;

  RefundItem({
    required this.id,
    required this.providerLogo,
    required this.providerName,
    required this.approvalNumber,
    required this.isRequest,
    required this.date,
    required this.time,
    required this.status,
    required this.statusChar,
    required this.notes,
    this.totalAmount,
    required this.refundDate,
    this.refundReasonId,
    this.refundTypeId,
    required this.attachmentsFolder,
  });

  factory RefundItem.fromJson(Map<String, dynamic> json) =>
      _$RefundItemFromJson(json);
  Map<String, dynamic> toJson() => _$RefundItemToJson(this);
}

@JsonSerializable()
class PaginationInfo {
  final int currentPage;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginationInfo({
    required this.currentPage,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) =>
      _$PaginationInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationInfoToJson(this);
}

@JsonSerializable()
class FilterInfo {
  final String status;

  FilterInfo({
    required this.status,
  });

  factory FilterInfo.fromJson(Map<String, dynamic> json) =>
      _$FilterInfoFromJson(json);
  Map<String, dynamic> toJson() => _$FilterInfoToJson(this);
}
