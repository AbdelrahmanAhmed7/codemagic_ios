import 'package:json_annotation/json_annotation.dart';

part 'register_request_model.g.dart';

@JsonSerializable()
class RegisterRequestModel {
  @JsonKey(name: "cardNo")
  final String cardNo;

  @JsonKey(name: "nationalId")
  final String nationalId;

  @JsonKey(name: "phoneNumber")
  final String phoneNumber;

  @JsonKey(name: "password")
  final String password;

  @JsonKey(name: "confirmPassword")
  final String confirmPassword;

  RegisterRequestModel({
    required this.cardNo,
    required this.nationalId,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => _$RegisterRequestModelToJson(this);
}