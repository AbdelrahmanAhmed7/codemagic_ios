import 'package:json_annotation/json_annotation.dart';

part 'login_request_model.g.dart';

@JsonSerializable()
class LoginRequestModel {
  @JsonKey(name: "cardNo")
  final String cardNo;

  @JsonKey(name: "password")
  final String password;

  LoginRequestModel({required this.cardNo, required this.password});

  Map<String, dynamic> toJson() => _$LoginRequestModelToJson(this);
}