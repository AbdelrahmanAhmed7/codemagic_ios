import 'package:json_annotation/json_annotation.dart';
import 'register_data_model.dart';

part 'register_response_model.g.dart';

@JsonSerializable()
class RegisterResponseModel {
  @JsonKey(name: "success")
  final bool success;

  @JsonKey(name: "timestamp")
  final String timestamp;

  @JsonKey(name: "message")
  final String message;

  @JsonKey(name: "data")
  final RegisterDataModel? data;

  RegisterResponseModel({
    required this.success,
    required this.timestamp,
    required this.message,
    this.data,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseModelFromJson(json);
}