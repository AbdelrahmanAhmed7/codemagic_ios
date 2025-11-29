// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refund_types_reasons_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefundTypesResponse _$RefundTypesResponseFromJson(Map<String, dynamic> json) =>
    RefundTypesResponse(
      success: json['success'] as bool,
      timestamp: json['timestamp'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : RefundTypesData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RefundTypesResponseToJson(
  RefundTypesResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'timestamp': instance.timestamp,
  'message': instance.message,
  'data': instance.data?.toJson(),
};

RefundTypesData _$RefundTypesDataFromJson(Map<String, dynamic> json) =>
    RefundTypesData(
      refundTypes: (json['refundTypes'] as List<dynamic>)
          .map((e) => RefundType.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RefundTypesDataToJson(RefundTypesData instance) =>
    <String, dynamic>{'refundTypes': instance.refundTypes};

RefundType _$RefundTypeFromJson(Map<String, dynamic> json) => RefundType(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  attachments:
      (json['attachments'] as List<dynamic>?)
          ?.map((e) => RefundAttachment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$RefundTypeToJson(RefundType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'attachments': instance.attachments,
    };

RefundAttachment _$RefundAttachmentFromJson(Map<String, dynamic> json) =>
    RefundAttachment(
      title: json['title'] as String,
      isRequired: json['isRequired'] as bool,
    );

Map<String, dynamic> _$RefundAttachmentToJson(RefundAttachment instance) =>
    <String, dynamic>{
      'title': instance.title,
      'isRequired': instance.isRequired,
    };

RefundReasonsResponse _$RefundReasonsResponseFromJson(
  Map<String, dynamic> json,
) => RefundReasonsResponse(
  success: json['success'] as bool,
  timestamp: json['timestamp'] as String?,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : RefundReasonsData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RefundReasonsResponseToJson(
  RefundReasonsResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'timestamp': instance.timestamp,
  'message': instance.message,
  'data': instance.data?.toJson(),
};

RefundReasonsData _$RefundReasonsDataFromJson(Map<String, dynamic> json) =>
    RefundReasonsData(
      refundReasons: (json['refundReasons'] as List<dynamic>)
          .map((e) => RefundReason.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RefundReasonsDataToJson(RefundReasonsData instance) =>
    <String, dynamic>{'refundReasons': instance.refundReasons};

RefundReason _$RefundReasonFromJson(Map<String, dynamic> json) =>
    RefundReason(id: (json['id'] as num).toInt(), name: json['name'] as String);

Map<String, dynamic> _$RefundReasonToJson(RefundReason instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
