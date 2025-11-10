// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refund_request_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefundRequestResponse _$RefundRequestResponseFromJson(
  Map<String, dynamic> json,
) => RefundRequestResponse(
  success: json['success'] as bool,
  timestamp: json['timestamp'] as String?,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : RefundRequestResponseData.fromJson(
          json['data'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$RefundRequestResponseToJson(
  RefundRequestResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'timestamp': instance.timestamp,
  'message': instance.message,
  'data': instance.data?.toJson(),
};

RefundRequestResponseData _$RefundRequestResponseDataFromJson(
  Map<String, dynamic> json,
) => RefundRequestResponseData(
  refund: RefundEntity.fromJson(json['refund'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RefundRequestResponseDataToJson(
  RefundRequestResponseData instance,
) => <String, dynamic>{'refund': instance.refund};

RefundEntity _$RefundEntityFromJson(Map<String, dynamic> json) => RefundEntity(
  id: (json['id'] as num).toInt(),
  providerLogo: json['providerLogo'] as String,
  providerName: json['providerName'] as String,
  approvalNumber: json['approvalNumber'] as String,
  isRequest: json['isRequest'] as bool,
  date: json['date'] as String,
  time: json['time'] as String,
  refundDate: json['refundDate'] as String,
  status: json['status'] as String,
  statusChar: json['statusChar'] as String,
  notes: json['notes'] as String,
  totalAmount: (json['totalAmount'] as num).toDouble(),
  refundReasonId: (json['refundReasonId'] as num).toInt(),
  refundTypeId: (json['refundTypeId'] as num).toInt(),
  attachmentsFolder: json['attachmentsFolder'] as String,
  attachments: (json['attachments'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$RefundEntityToJson(RefundEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'providerLogo': instance.providerLogo,
      'providerName': instance.providerName,
      'approvalNumber': instance.approvalNumber,
      'isRequest': instance.isRequest,
      'date': instance.date,
      'time': instance.time,
      'refundDate': instance.refundDate,
      'status': instance.status,
      'statusChar': instance.statusChar,
      'notes': instance.notes,
      'totalAmount': instance.totalAmount,
      'refundReasonId': instance.refundReasonId,
      'refundTypeId': instance.refundTypeId,
      'attachmentsFolder': instance.attachmentsFolder,
      'attachments': instance.attachments,
    };
