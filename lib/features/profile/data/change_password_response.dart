import 'package:json_annotation/json_annotation.dart';
import 'change_password_data.dart';

part 'change_password_response.g.dart';

@JsonSerializable()
class ChangePasswordResponse {
  @JsonKey(name: "success")
  final bool success;

  @JsonKey(name: "timestamp")
  final String timestamp;

  @JsonKey(name: "message")
  final String message;

  @JsonKey(name: "data")
  final ChangePasswordData? data;

  ChangePasswordResponse({
    required this.success,
    required this.timestamp,
    required this.message,
    this.data,
  });

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordResponseFromJson(json);
      
  Map<String, dynamic> toJson() => _$ChangePasswordResponseToJson(this);
}
