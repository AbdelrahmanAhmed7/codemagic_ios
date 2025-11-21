import 'package:json_annotation/json_annotation.dart';

part 'refund_request_models.g.dart';

@JsonSerializable(explicitToJson: true)
class RefundRequestResponse {
  final bool success;
  final String? timestamp;
  final String? message;
  final RefundRequestResponseData? data;

  RefundRequestResponse({
    required this.success,
    this.timestamp,
    this.message,
    this.data,
  });

  factory RefundRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$RefundRequestResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RefundRequestResponseToJson(this);
}

@JsonSerializable()
class RefundRequestResponseData {
  final RefundEntity refund;

  RefundRequestResponseData({
    required this.refund,
  });

  factory RefundRequestResponseData.fromJson(Map<String, dynamic> json) =>
      _$RefundRequestResponseDataFromJson(json);
  Map<String, dynamic> toJson() => _$RefundRequestResponseDataToJson(this);
}

@JsonSerializable()
class RefundEntity {
  final int id;
  final String providerLogo;
  final String providerName;
  final String approvalNumber;
  final bool isRequest;
  final String date;
  final String time;
  final String refundDate;
  final String status;
  final String statusChar;
  final String notes;
  final double totalAmount;
  final int refundReasonId;
  final int refundTypeId;
  final String attachmentsFolder;
  final List<String> attachments;

  RefundEntity({
    required this.id,
    required this.providerLogo,
    required this.providerName,
    required this.approvalNumber,
    required this.isRequest,
    required this.date,
    required this.time,
    required this.refundDate,
    required this.status,
    required this.statusChar,
    required this.notes,
    required this.totalAmount,
    required this.refundReasonId,
    required this.refundTypeId,
    required this.attachmentsFolder,
    required this.attachments,
  });

  factory RefundEntity.fromJson(Map<String, dynamic> json) =>
      _$RefundEntityFromJson(json);
  Map<String, dynamic> toJson() => _$RefundEntityToJson(this);
}
