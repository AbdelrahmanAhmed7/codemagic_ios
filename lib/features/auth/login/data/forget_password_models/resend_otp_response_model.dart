import 'package:json_annotation/json_annotation.dart';

part 'resend_otp_response_model.g.dart';

@JsonSerializable()
class ResendOtpResponseModel {
  final bool success;
  final String timestamp;
  final String message;
  final ResendOtpData? data;

  ResendOtpResponseModel({
    required this.success,
    required this.timestamp,
    required this.message,
    this.data,
  });

  factory ResendOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ResendOtpResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResendOtpResponseModelToJson(this);
}

@JsonSerializable()
class ResendOtpData {
  final String? otp;

  ResendOtpData({this.otp});

  factory ResendOtpData.fromJson(Map<String, dynamic> json) =>
      _$ResendOtpDataFromJson(json);

  Map<String, dynamic> toJson() => _$ResendOtpDataToJson(this);
}
