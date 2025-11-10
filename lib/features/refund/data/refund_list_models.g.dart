// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refund_list_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefundListResponse _$RefundListResponseFromJson(Map<String, dynamic> json) =>
    RefundListResponse(
      success: json['success'] as bool,
      timestamp: json['timestamp'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : RefundListData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RefundListResponseToJson(RefundListResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'timestamp': instance.timestamp,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };

RefundListData _$RefundListDataFromJson(Map<String, dynamic> json) =>
    RefundListData(
      refunds: (json['refunds'] as List<dynamic>)
          .map((e) => RefundItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: PaginationInfo.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
      filter: FilterInfo.fromJson(json['filter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RefundListDataToJson(RefundListData instance) =>
    <String, dynamic>{
      'refunds': instance.refunds,
      'pagination': instance.pagination,
      'filter': instance.filter,
    };

RefundItem _$RefundItemFromJson(Map<String, dynamic> json) => RefundItem(
  id: (json['id'] as num).toInt(),
  providerLogo: json['providerLogo'] as String,
  providerName: json['providerName'] as String,
  approvalNumber: json['approvalNumber'] as String,
  isRequest: json['isRequest'] as bool,
  date: json['date'] as String,
  time: json['time'] as String,
  status: json['status'] as String,
  statusChar: json['statusChar'] as String,
  notes: json['notes'] as String,
  totalAmount: (json['totalAmount'] as num?)?.toDouble(),
  refundDate: json['refundDate'] as String,
  refundReasonId: (json['refundReasonId'] as num?)?.toInt(),
  refundTypeId: (json['refundTypeId'] as num?)?.toInt(),
  attachmentsFolder: json['attachmentsFolder'] as String,
);

Map<String, dynamic> _$RefundItemToJson(RefundItem instance) =>
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
      'totalAmount': instance.totalAmount,
      'refundDate': instance.refundDate,
      'refundReasonId': instance.refundReasonId,
      'refundTypeId': instance.refundTypeId,
      'attachmentsFolder': instance.attachmentsFolder,
    };

PaginationInfo _$PaginationInfoFromJson(Map<String, dynamic> json) =>
    PaginationInfo(
      currentPage: (json['currentPage'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      totalCount: (json['totalCount'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      hasNextPage: json['hasNextPage'] as bool,
      hasPreviousPage: json['hasPreviousPage'] as bool,
    );

Map<String, dynamic> _$PaginationInfoToJson(PaginationInfo instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'pageSize': instance.pageSize,
      'totalCount': instance.totalCount,
      'totalPages': instance.totalPages,
      'hasNextPage': instance.hasNextPage,
      'hasPreviousPage': instance.hasPreviousPage,
    };

FilterInfo _$FilterInfoFromJson(Map<String, dynamic> json) =>
    FilterInfo(status: json['status'] as String);

Map<String, dynamic> _$FilterInfoToJson(FilterInfo instance) =>
    <String, dynamic>{'status': instance.status};
