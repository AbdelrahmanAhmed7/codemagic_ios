// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPasswordResponseModel _$ResetPasswordResponseModelFromJson(
  Map<String, dynamic> json,
) => ResetPasswordResponseModel(
  success: json['success'] as bool,
  timestamp: json['timestamp'] as String,
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : ResetPasswordData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ResetPasswordResponseModelToJson(
  ResetPasswordResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'timestamp': instance.timestamp,
  'message': instance.message,
  'data': instance.data,
};

ResetPasswordData _$ResetPasswordDataFromJson(Map<String, dynamic> json) =>
    ResetPasswordData(memberId: (json['memberId'] as num).toInt());

Map<String, dynamic> _$ResetPasswordDataToJson(ResetPasswordData instance) =>
    <String, dynamic>{'memberId': instance.memberId};
