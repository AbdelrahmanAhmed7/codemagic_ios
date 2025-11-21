// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalInfoResponse _$PersonalInfoResponseFromJson(
  Map<String, dynamic> json,
) => PersonalInfoResponse(
  success: json['success'] as bool,
  timestamp: json['timestamp'] as String,
  message: json['message'] as String,
  data: PersonalInfoData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PersonalInfoResponseToJson(
  PersonalInfoResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'timestamp': instance.timestamp,
  'message': instance.message,
  'data': instance.data,
};

PersonalInfoData _$PersonalInfoDataFromJson(Map<String, dynamic> json) =>
    PersonalInfoData(
      memberName: json['memberName'] as String,
      image: json['image'] as String,
      memberId: (json['memberId'] as num).toInt(),
      mobile: json['mobile'] as String,
      birthdate: json['birthdate'] as String,
      isMale: json['isMale'] as bool,
      address: json['address'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$PersonalInfoDataToJson(PersonalInfoData instance) =>
    <String, dynamic>{
      'memberName': instance.memberName,
      'image': instance.image,
      'memberId': instance.memberId,
      'mobile': instance.mobile,
      'birthdate': instance.birthdate,
      'isMale': instance.isMale,
      'address': instance.address,
      'email': instance.email,
    };
