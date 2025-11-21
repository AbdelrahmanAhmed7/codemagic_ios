// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginDataModel _$LoginDataModelFromJson(Map<String, dynamic> json) =>
    LoginDataModel(
      token: json['token'] as String,
      memberId: (json['memberId'] as num).toInt(),
      memberName: json['memberName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      nationalId: LoginDataModel._fromJsonToString(json['nationalId']),
    );

Map<String, dynamic> _$LoginDataModelToJson(LoginDataModel instance) =>
    <String, dynamic>{
      'token': instance.token,
      'memberId': instance.memberId,
      'memberName': instance.memberName,
      'phoneNumber': instance.phoneNumber,
      'nationalId': instance.nationalId,
    };
