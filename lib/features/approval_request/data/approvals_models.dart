import 'package:json_annotation/json_annotation.dart';

part 'approvals_models.g.dart';

@JsonSerializable(explicitToJson: true)
class ApprovalsResponse {
  final bool success;
  final String? timestamp;
  final String? message;
  final ApprovalsData? data;

  ApprovalsResponse({
    required this.success,
    this.timestamp,
    this.message,
    this.data,
  });

  factory ApprovalsResponse.fromJson(Map<String, dynamic> json) => _$ApprovalsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ApprovalsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ApprovalsData {
  final List<ApprovalItem> approvals;
  final Pagination pagination;
  final ApprovalsFilter filter;

  ApprovalsData({
    required this.approvals,
    required this.pagination,
    required this.filter,
  });

  factory ApprovalsData.fromJson(Map<String, dynamic> json) => _$ApprovalsDataFromJson(json);
  Map<String, dynamic> toJson() => _$ApprovalsDataToJson(this);
}

@JsonSerializable()
class ApprovalItem {
  final int id;
  final String? providerLogo;
  final String providerName;
  final String approvalNumber;
  final bool isRequest;
  final String date;
  final String time;
  final String status;
  final String statusChar; // P/A/R
  final String? notes;

  ApprovalItem({
    required this.id,
    this.providerLogo,
    required this.providerName,
    required this.approvalNumber,
    required this.isRequest,
    required this.date,
    required this.time,
    required this.status,
    required this.statusChar,
    this.notes,
  });

  factory ApprovalItem.fromJson(Map<String, dynamic> json) => _$ApprovalItemFromJson(json);
  Map<String, dynamic> toJson() => _$ApprovalItemToJson(this);
}

@JsonSerializable()
class Pagination {
  final int currentPage;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  Pagination({
    required this.currentPage,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => _$PaginationFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}

@JsonSerializable()
class ApprovalsFilter {
  final String status; // All/0 or etc.

  ApprovalsFilter({required this.status});

  factory ApprovalsFilter.fromJson(Map<String, dynamic> json) => _$ApprovalsFilterFromJson(json);
  Map<String, dynamic> toJson() => _$ApprovalsFilterToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ApprovalPdfResponse {
  final bool success;
  final String? timestamp;
  final String? message;
  final ApprovalPdfData? data;

  ApprovalPdfResponse({
    required this.success,
    this.timestamp,
    this.message,
    this.data,
  });

  factory ApprovalPdfResponse.fromJson(Map<String, dynamic> json) => _$ApprovalPdfResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ApprovalPdfResponseToJson(this);
}

@JsonSerializable()
class ApprovalPdfData {
  final String url;

  ApprovalPdfData({required this.url});

  factory ApprovalPdfData.fromJson(Map<String, dynamic> json) => _$ApprovalPdfDataFromJson(json);
  Map<String, dynamic> toJson() => _$ApprovalPdfDataToJson(this);
}


