// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeResponse _$HomeResponseFromJson(Map<String, dynamic> json) => HomeResponse(
  success: json['success'] as bool,
  timestamp: json['timestamp'] as String,
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : HomeData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$HomeResponseToJson(HomeResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'timestamp': instance.timestamp,
      'message': instance.message,
      'data': instance.data,
    };

HomeData _$HomeDataFromJson(Map<String, dynamic> json) => HomeData(
  memberId: (json['memberId'] as num).toInt(),
  memberName: json['memberName'] as String,
  policyExpireDate: json['policyExpireDate'] as String,
  programName: json['programName'] as String,
  programColor: json['programColor'] as String,
  notificationsCount: (json['notificationsCount'] as num).toInt(),
  memberPhoto: json['memberPhoto'] as String?,
  approvals: (json['approvals'] as List<dynamic>)
      .map((e) => Approval.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$HomeDataToJson(HomeData instance) => <String, dynamic>{
  'memberId': instance.memberId,
  'memberName': instance.memberName,
  'policyExpireDate': instance.policyExpireDate,
  'programName': instance.programName,
  'programColor': instance.programColor,
  'notificationsCount': instance.notificationsCount,
  'memberPhoto': instance.memberPhoto,
  'approvals': instance.approvals,
};

Approval _$ApprovalFromJson(Map<String, dynamic> json) => Approval(
  id: (json['id'] as num).toInt(),
  providerLogo: json['providerLogo'] as String,
  providerName: json['providerName'] as String,
  status: json['status'] as String,
  createdDate: json['createdDate'] as String,
  notes: json['notes'] as String,
);

Map<String, dynamic> _$ApprovalToJson(Approval instance) => <String, dynamic>{
  'id': instance.id,
  'providerLogo': instance.providerLogo,
  'providerName': instance.providerName,
  'status': instance.status,
  'createdDate': instance.createdDate,
  'notes': instance.notes,
};
