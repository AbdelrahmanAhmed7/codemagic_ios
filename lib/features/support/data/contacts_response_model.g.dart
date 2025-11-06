// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactsResponse _$ContactsResponseFromJson(Map<String, dynamic> json) =>
    ContactsResponse(
      success: json['success'] as bool,
      timestamp: json['timestamp'] as String,
      message: json['message'] as String,
      data: ContactData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ContactsResponseToJson(ContactsResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'timestamp': instance.timestamp,
      'message': instance.message,
      'data': instance.data,
    };

ContactData _$ContactDataFromJson(Map<String, dynamic> json) => ContactData(
  email: json['email'] as String,
  hotLine: json['hotLine'] as String,
  whatsApp: json['whatsApp'] as String,
  website: json['website'] as String,
  linkedIn: json['linkedIn'] as String,
  facebook: json['facebook'] as String,
  instagram: json['instagram'] as String,
);

Map<String, dynamic> _$ContactDataToJson(ContactData instance) =>
    <String, dynamic>{
      'email': instance.email,
      'hotLine': instance.hotLine,
      'whatsApp': instance.whatsApp,
      'website': instance.website,
      'linkedIn': instance.linkedIn,
      'facebook': instance.facebook,
      'instagram': instance.instagram,
    };
