import 'package:json_annotation/json_annotation.dart';

part 'change_password_data.g.dart';

@JsonSerializable()
class ChangePasswordData {
  @JsonKey(name: "memberId")
  final int memberId;

  ChangePasswordData({
    required this.memberId,
  });

  factory ChangePasswordData.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordDataFromJson(json);
      
  Map<String, dynamic> toJson() => _$ChangePasswordDataToJson(this);
}
