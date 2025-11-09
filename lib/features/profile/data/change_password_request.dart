import 'package:json_annotation/json_annotation.dart';

part 'change_password_request.g.dart';

@JsonSerializable()
class ChangePasswordRequest {
  @JsonKey(name: "oldPassword")
  final String oldPassword;

  @JsonKey(name: "newPassword")
  final String newPassword;

  @JsonKey(name: "confirmNewPassword")
  final String confirmNewPassword;

  ChangePasswordRequest({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  Map<String, dynamic> toJson() => _$ChangePasswordRequestToJson(this);
}
