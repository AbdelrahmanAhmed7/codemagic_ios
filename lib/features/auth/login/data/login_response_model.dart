import 'package:json_annotation/json_annotation.dart';
import 'login_data_model.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel {
  @JsonKey(name: "success")
  final bool success;

  @JsonKey(name: "timestamp")
  final String timestamp;

  @JsonKey(name: "message")
  final String message;

  @JsonKey(name: "data")
  final LoginDataModel? data;

  LoginResponseModel({
    required this.success,
    required this.timestamp,
    required this.message,
    this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);
}