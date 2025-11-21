// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resend_otp_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResendOtpResponseModel _$ResendOtpResponseModelFromJson(
  Map<String, dynamic> json,
) => ResendOtpResponseModel(
  success: json['success'] as bool,
  timestamp: json['timestamp'] as String,
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : ResendOtpData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ResendOtpResponseModelToJson(
  ResendOtpResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'timestamp': instance.timestamp,
  'message': instance.message,
  'data': instance.data,
};

ResendOtpData _$ResendOtpDataFromJson(Map<String, dynamic> json) =>
    ResendOtpData(otp: json['otp'] as String?);

Map<String, dynamic> _$ResendOtpDataToJson(ResendOtpData instance) =>
    <String, dynamic>{'otp': instance.otp};
