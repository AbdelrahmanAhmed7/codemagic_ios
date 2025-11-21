// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approvals_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApprovalsResponse _$ApprovalsResponseFromJson(Map<String, dynamic> json) =>
    ApprovalsResponse(
      success: json['success'] as bool,
      timestamp: json['timestamp'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : ApprovalsData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApprovalsResponseToJson(ApprovalsResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'timestamp': instance.timestamp,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };

ApprovalsData _$ApprovalsDataFromJson(Map<String, dynamic> json) =>
    ApprovalsData(
      approvals: (json['approvals'] as List<dynamic>)
          .map((e) => ApprovalItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
      filter: ApprovalsFilter.fromJson(json['filter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApprovalsDataToJson(ApprovalsData instance) =>
    <String, dynamic>{
      'approvals': instance.approvals.map((e) => e.toJson()).toList(),
      'pagination': instance.pagination.toJson(),
      'filter': instance.filter.toJson(),
    };

ApprovalItem _$ApprovalItemFromJson(Map<String, dynamic> json) => ApprovalItem(
  id: (json['id'] as num).toInt(),
  providerLogo: json['providerLogo'] as String?,
  providerName: json['providerName'] as String,
  approvalNumber: json['approvalNumber'] as String,
  isRequest: json['isRequest'] as bool,
  date: json['date'] as String,
  time: json['time'] as String,
  status: json['status'] as String,
  statusChar: json['statusChar'] as String,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$ApprovalItemToJson(ApprovalItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'providerLogo': instance.providerLogo,
      'providerName': instance.providerName,
      'approvalNumber': instance.approvalNumber,
      'isRequest': instance.isRequest,
      'date': instance.date,
      'time': instance.time,
      'status': instance.status,
      'statusChar': instance.statusChar,
      'notes': instance.notes,
    };

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
  currentPage: (json['currentPage'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  totalCount: (json['totalCount'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  hasNextPage: json['hasNextPage'] as bool,
  hasPreviousPage: json['hasPreviousPage'] as bool,
);

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'pageSize': instance.pageSize,
      'totalCount': instance.totalCount,
      'totalPages': instance.totalPages,
      'hasNextPage': instance.hasNextPage,
      'hasPreviousPage': instance.hasPreviousPage,
    };

ApprovalsFilter _$ApprovalsFilterFromJson(Map<String, dynamic> json) =>
    ApprovalsFilter(status: json['status'] as String);

Map<String, dynamic> _$ApprovalsFilterToJson(ApprovalsFilter instance) =>
    <String, dynamic>{'status': instance.status};

ApprovalPdfResponse _$ApprovalPdfResponseFromJson(Map<String, dynamic> json) =>
    ApprovalPdfResponse(
      success: json['success'] as bool,
      timestamp: json['timestamp'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : ApprovalPdfData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApprovalPdfResponseToJson(
  ApprovalPdfResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'timestamp': instance.timestamp,
  'message': instance.message,
  'data': instance.data?.toJson(),
};

ApprovalPdfData _$ApprovalPdfDataFromJson(Map<String, dynamic> json) =>
    ApprovalPdfData(url: json['url'] as String);

Map<String, dynamic> _$ApprovalPdfDataToJson(ApprovalPdfData instance) =>
    <String, dynamic>{'url': instance.url};
