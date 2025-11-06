import 'package:json_annotation/json_annotation.dart';

part 'personal_info_response.g.dart';

@JsonSerializable()
class PersonalInfoResponse {
  final bool success;
  final String timestamp;
  final String message;
  final PersonalInfoData data;

  PersonalInfoResponse({
    required this.success,
    required this.timestamp,
    required this.message,
    required this.data,
  });

  factory PersonalInfoResponse.fromJson(Map<String, dynamic> json) => _$PersonalInfoResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PersonalInfoResponseToJson(this);
}

@JsonSerializable()
class PersonalInfoData {
  final String memberName;
  final String image;
  final int memberId;
  final String mobile;
  final String birthdate;
  final bool isMale;
  final String address;
  final String email;

  PersonalInfoData({
    required this.memberName,
    required this.image,
    required this.memberId,
    required this.mobile,
    required this.birthdate,
    required this.isMale,
    required this.address,
    required this.email,
  });

  factory PersonalInfoData.fromJson(Map<String, dynamic> json) => _$PersonalInfoDataFromJson(json);
  Map<String, dynamic> toJson() => _$PersonalInfoDataToJson(this);
}


