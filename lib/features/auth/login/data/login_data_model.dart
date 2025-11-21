import 'package:json_annotation/json_annotation.dart';

part 'login_data_model.g.dart';

@JsonSerializable()
class LoginDataModel {
  @JsonKey(name: "token")
  final String token;

  @JsonKey(name: "memberId")
  final int memberId;

  @JsonKey(name: "memberName")
  final String memberName;

  @JsonKey(name: "phoneNumber")
  final String phoneNumber;

  @JsonKey(name: "nationalId", fromJson: _fromJsonToString)
  final String nationalId;

  LoginDataModel({
    required this.token,
    required this.memberId,
    required this.memberName,
    required this.phoneNumber,
    required this.nationalId,
  });

  factory LoginDataModel.fromJson(Map<String, dynamic> json) =>
      _$LoginDataModelFromJson(json);

  static String _fromJsonToString(dynamic value) => value?.toString() ?? '';
}