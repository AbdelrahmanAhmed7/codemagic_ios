import 'package:json_annotation/json_annotation.dart';

part 'home_response_model.g.dart';

@JsonSerializable()
class HomeResponse {
  final bool success;
  final String timestamp;
  final String message;
  final HomeData? data;

  HomeResponse({
    required this.success,
    required this.timestamp,
    required this.message,
    this.data,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HomeResponseToJson(this);
}

@JsonSerializable()
class HomeData {
  final int memberId;
  final String memberName;
  final String policyExpireDate;
  final String programName;
  final String programColor;
  final int notificationsCount;
  final String? memberPhoto; 
  final List<Approval> approvals;

  HomeData({
    required this.memberId,
    required this.memberName,
    required this.policyExpireDate,
    required this.programName,
    required this.programColor,
    required this.notificationsCount,
    this.memberPhoto,
    required this.approvals,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) =>
      _$HomeDataFromJson(json);

  Map<String, dynamic> toJson() => _$HomeDataToJson(this);
}

@JsonSerializable()
class Approval {
  final int id;
  final String providerLogo;
  final String providerName;
  final String status;
  final String createdDate;
  final String notes;

  Approval({
    required this.id,
    required this.providerLogo,
    required this.providerName,
    required this.status,
    required this.createdDate,
    required this.notes,
  });

  factory Approval.fromJson(Map<String, dynamic> json) =>
      _$ApprovalFromJson(json);

  Map<String, dynamic> toJson() => _$ApprovalToJson(this);
}
