// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_request_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApprovalRequestResponse _$ApprovalRequestResponseFromJson(
  Map<String, dynamic> json,
) => ApprovalRequestResponse(
  success: json['success'] as bool,
  timestamp: json['timestamp'] as String?,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : ApprovalRequestData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ApprovalRequestResponseToJson(
  ApprovalRequestResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'timestamp': instance.timestamp,
  'message': instance.message,
  'data': instance.data?.toJson(),
};

ApprovalRequestData _$ApprovalRequestDataFromJson(Map<String, dynamic> json) =>
    ApprovalRequestData(
      id: (json['id'] as num).toInt(),
      memberId: (json['memberId'] as num).toInt(),
      providerId: (json['providerId'] as num).toInt(),
      status: json['status'] as String,
      createdDate: json['createdDate'] as String,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$ApprovalRequestDataToJson(
  ApprovalRequestData instance,
) => <String, dynamic>{
  'id': instance.id,
  'memberId': instance.memberId,
  'providerId': instance.providerId,
  'status': instance.status,
  'createdDate': instance.createdDate,
  'notes': instance.notes,
};

ApprovalRequestModel _$ApprovalRequestModelFromJson(
  Map<String, dynamic> json,
) => ApprovalRequestModel(
  memberId: (json['memberId'] as num).toInt(),
  providerId: (json['providerId'] as num).toInt(),
  notes: json['notes'] as String?,
  attachments: (json['attachments'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$ApprovalRequestModelToJson(
  ApprovalRequestModel instance,
) => <String, dynamic>{
  'memberId': instance.memberId,
  'providerId': instance.providerId,
  'notes': instance.notes,
  'attachments': instance.attachments,
};
