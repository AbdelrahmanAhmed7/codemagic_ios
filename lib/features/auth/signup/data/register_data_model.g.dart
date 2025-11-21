// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterDataModel _$RegisterDataModelFromJson(Map<String, dynamic> json) =>
    RegisterDataModel(
      token: json['token'] as String,
      memberId: (json['memberId'] as num).toInt(),
      memberName: json['memberName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      nationalId: RegisterDataModel._fromJsonToString(json['nationalId']),
    );

Map<String, dynamic> _$RegisterDataModelToJson(RegisterDataModel instance) =>
    <String, dynamic>{
      'token': instance.token,
      'memberId': instance.memberId,
      'memberName': instance.memberName,
      'phoneNumber': instance.phoneNumber,
      'nationalId': instance.nationalId,
    };
