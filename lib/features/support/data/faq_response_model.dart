import 'package:json_annotation/json_annotation.dart';

part 'faq_response_model.g.dart';

@JsonSerializable()
class FAQResponse {
  final bool success;
  final String timestamp;
  final String message;
  final FAQData data;

  FAQResponse({
    required this.success,
    required this.timestamp,
    required this.message,
    required this.data,
  });

  factory FAQResponse.fromJson(Map<String, dynamic> json) => _$FAQResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FAQResponseToJson(this);
}

@JsonSerializable()
class FAQData {
  final List<FAQItem> faqs;

  FAQData({required this.faqs});

  factory FAQData.fromJson(Map<String, dynamic> json) => _$FAQDataFromJson(json);
  Map<String, dynamic> toJson() => _$FAQDataToJson(this);
}

@JsonSerializable()
class FAQItem {
  final int id;
  final String question;
  final String answer;
  final int visibilityOrder;

  FAQItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.visibilityOrder,
  });

  factory FAQItem.fromJson(Map<String, dynamic> json) => _$FAQItemFromJson(json);
  Map<String, dynamic> toJson() => _$FAQItemToJson(this);
}


