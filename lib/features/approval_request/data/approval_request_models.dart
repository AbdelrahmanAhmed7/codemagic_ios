import 'package:json_annotation/json_annotation.dart';

part 'approval_request_models.g.dart';

@JsonSerializable(explicitToJson: true)
class ApprovalRequestResponse {
  final bool success;
  final String? timestamp;
  final String? message;
  final ApprovalRequestData? data;

  ApprovalRequestResponse({
    required this.success,
    this.timestamp,
    this.message,
    this.data,
  });

  factory ApprovalRequestResponse.fromJson(Map<String, dynamic> json) => 
      _$ApprovalRequestResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ApprovalRequestResponseToJson(this);
}

@JsonSerializable()
class ApprovalRequestData {
  final int id;
  final int memberId;
  final int providerId;
  final String status;
  final String createdDate;
  final String? notes;

  ApprovalRequestData({
    required this.id,
    required this.memberId,
    required this.providerId,
    required this.status,
    required this.createdDate,
    this.notes,
  });

  factory ApprovalRequestData.fromJson(Map<String, dynamic> json) => 
      _$ApprovalRequestDataFromJson(json);
  Map<String, dynamic> toJson() => _$ApprovalRequestDataToJson(this);
}

@JsonSerializable()
class ApprovalRequestModel {
  final int memberId;
  final int providerId;
  final String? notes;
  final List<String> attachments;

  ApprovalRequestModel({
    required this.memberId,
    required this.providerId,
    this.notes,
    required this.attachments,
  });

  factory ApprovalRequestModel.fromJson(Map<String, dynamic> json) => 
      _$ApprovalRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$ApprovalRequestModelToJson(this);
}