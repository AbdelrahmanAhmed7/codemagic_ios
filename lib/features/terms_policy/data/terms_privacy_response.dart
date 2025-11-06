import 'package:json_annotation/json_annotation.dart';

part 'terms_privacy_response.g.dart';

@JsonSerializable()
class TermsPrivacyResponse {
  final bool success;
  final String timestamp;
  final String message;
  final TermsPrivacyData data;

  TermsPrivacyResponse({
    required this.success,
    required this.timestamp,
    required this.message,
    required this.data,
  });

  factory TermsPrivacyResponse.fromJson(Map<String, dynamic> json) => _$TermsPrivacyResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TermsPrivacyResponseToJson(this);
}

@JsonSerializable()
class TermsPrivacyData {
  final int id;
  final String description;

  TermsPrivacyData({required this.id, required this.description});

  factory TermsPrivacyData.fromJson(Map<String, dynamic> json) => _$TermsPrivacyDataFromJson(json);
  Map<String, dynamic> toJson() => _$TermsPrivacyDataToJson(this);
}


