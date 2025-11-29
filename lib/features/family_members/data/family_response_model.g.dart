// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FamilyResponse _$FamilyResponseFromJson(Map<String, dynamic> json) =>
    FamilyResponse(
      success: json['success'] as bool,
      timestamp: json['timestamp'] as String,
      message: json['message'] as String,
      data: FamilyData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FamilyResponseToJson(FamilyResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'timestamp': instance.timestamp,
      'message': instance.message,
      'data': instance.data.toJson(),
    };

FamilyData _$FamilyDataFromJson(Map<String, dynamic> json) => FamilyData(
  familyMembers: (json['familyMembers'] as List<dynamic>)
      .map((e) => FamilyMember.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalCount: (json['totalCount'] as num).toInt(),
);

Map<String, dynamic> _$FamilyDataToJson(FamilyData instance) =>
    <String, dynamic>{
      'familyMembers': instance.familyMembers.map((e) => e.toJson()).toList(),
      'totalCount': instance.totalCount,
    };

FamilyMember _$FamilyMemberFromJson(Map<String, dynamic> json) => FamilyMember(
  memberId: (json['memberId'] as num).toInt(),
  memberName: json['memberName'] as String,
  memberImage: json['memberImage'] as String?,
  level: json['level'] as String,
  memberHofId: (json['memberHofId'] as num).toInt(),
  isHeadOfFamily: json['isHeadOfFamily'] as bool,
  isActive: json['isActive'] as bool,
  memberStatus: json['memberStatus'] as String,
  programName: json['programName'] as String?,
);

Map<String, dynamic> _$FamilyMemberToJson(FamilyMember instance) =>
    <String, dynamic>{
      'memberId': instance.memberId,
      'memberName': instance.memberName,
      'memberImage': instance.memberImage,
      'level': instance.level,
      'memberHofId': instance.memberHofId,
      'isHeadOfFamily': instance.isHeadOfFamily,
      'isActive': instance.isActive,
      'memberStatus': instance.memberStatus,
      'programName': instance.programName,
    };
