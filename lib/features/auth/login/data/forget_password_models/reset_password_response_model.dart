import 'package:json_annotation/json_annotation.dart';

part 'reset_password_response_model.g.dart';

@JsonSerializable()
class ResetPasswordResponseModel {
  final bool success;
  final String timestamp;
  final String message;
  final ResetPasswordData? data;

  ResetPasswordResponseModel({
    required this.success,
    required this.timestamp,
    required this.message,
    this.data,
  });

  factory ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordResponseModelToJson(this);
}

@JsonSerializable()
class ResetPasswordData {
  final int memberId;

  ResetPasswordData({required this.memberId});

  factory ResetPasswordData.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordDataFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordDataToJson(this);
}
