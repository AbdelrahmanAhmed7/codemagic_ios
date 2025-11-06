// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terms_privacy_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TermsPrivacyResponse _$TermsPrivacyResponseFromJson(
  Map<String, dynamic> json,
) => TermsPrivacyResponse(
  success: json['success'] as bool,
  timestamp: json['timestamp'] as String,
  message: json['message'] as String,
  data: TermsPrivacyData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TermsPrivacyResponseToJson(
  TermsPrivacyResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'timestamp': instance.timestamp,
  'message': instance.message,
  'data': instance.data,
};

TermsPrivacyData _$TermsPrivacyDataFromJson(Map<String, dynamic> json) =>
    TermsPrivacyData(
      id: (json['id'] as num).toInt(),
      description: json['description'] as String,
    );

Map<String, dynamic> _$TermsPrivacyDataToJson(TermsPrivacyData instance) =>
    <String, dynamic>{'id': instance.id, 'description': instance.description};
