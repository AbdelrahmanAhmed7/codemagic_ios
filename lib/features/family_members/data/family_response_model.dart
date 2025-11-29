import 'package:json_annotation/json_annotation.dart';

part 'family_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FamilyResponse {
  final bool success;
  final String timestamp;
  final String message;
  final FamilyData data;

  FamilyResponse({
    required this.success,
    required this.timestamp,
    required this.message,
    required this.data,
  });

  factory FamilyResponse.fromJson(Map<String, dynamic> json) => _$FamilyResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FamilyResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class FamilyData {
  final List<FamilyMember> familyMembers;
  final int totalCount;

  FamilyData({
    required this.familyMembers,
    required this.totalCount,
  });

  factory FamilyData.fromJson(Map<String, dynamic> json) => _$FamilyDataFromJson(json);
  Map<String, dynamic> toJson() => _$FamilyDataToJson(this);
}

@JsonSerializable()
class FamilyMember {
  final int memberId;
  final String memberName;
  final String? memberImage;
  final String level;
  final int memberHofId;
  final bool isHeadOfFamily;
  final bool isActive;
  final String memberStatus;
  final String? programName;

  FamilyMember({
    required this.memberId,
    required this.memberName,
    this.memberImage,
    required this.level,
    required this.memberHofId,
    required this.isHeadOfFamily,
    required this.isActive,
    required this.memberStatus,
    this.programName,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) => _$FamilyMemberFromJson(json);
  Map<String, dynamic> toJson() => _$FamilyMemberToJson(this);
}
