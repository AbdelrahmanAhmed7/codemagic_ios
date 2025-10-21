import 'package:json_annotation/json_annotation.dart';

part 'otp_response_model.g.dart';

@JsonSerializable()
class OtpResponseModel {
  final bool success;
  final String timestamp;
  final String message;
  final OtpData? data;

  OtpResponseModel({
    required this.success,
    required this.timestamp,
    required this.message,
    this.data,
  });

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OtpResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$OtpResponseModelToJson(this);
}

@JsonSerializable()
class OtpData {
  final String? otp;

  OtpData({this.otp});

  factory OtpData.fromJson(Map<String, dynamic> json) =>
      _$OtpDataFromJson(json);

  Map<String, dynamic> toJson() => _$OtpDataToJson(this);
}
