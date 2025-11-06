import 'package:json_annotation/json_annotation.dart';

part 'contacts_response_model.g.dart';

@JsonSerializable()
class ContactsResponse {
  final bool success;
  final String timestamp;
  final String message;
  final ContactData data;

  ContactsResponse({
    required this.success,
    required this.timestamp,
    required this.message,
    required this.data,
  });

  factory ContactsResponse.fromJson(Map<String, dynamic> json) => _$ContactsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ContactsResponseToJson(this);
}

@JsonSerializable()
class ContactData {
  final String email;
  final String hotLine;
  final String whatsApp;
  final String website;
  final String linkedIn;
  final String facebook;
  final String instagram;

  ContactData({
    required this.email,
    required this.hotLine,
    required this.whatsApp,
    required this.website,
    required this.linkedIn,
    required this.facebook,
    required this.instagram,
  });

  factory ContactData.fromJson(Map<String, dynamic> json) => _$ContactDataFromJson(json);
  Map<String, dynamic> toJson() => _$ContactDataToJson(this);
}


