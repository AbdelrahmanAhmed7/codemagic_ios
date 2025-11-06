// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FAQResponse _$FAQResponseFromJson(Map<String, dynamic> json) => FAQResponse(
  success: json['success'] as bool,
  timestamp: json['timestamp'] as String,
  message: json['message'] as String,
  data: FAQData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FAQResponseToJson(FAQResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'timestamp': instance.timestamp,
      'message': instance.message,
      'data': instance.data,
    };

FAQData _$FAQDataFromJson(Map<String, dynamic> json) => FAQData(
  faqs: (json['faqs'] as List<dynamic>)
      .map((e) => FAQItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$FAQDataToJson(FAQData instance) => <String, dynamic>{
  'faqs': instance.faqs,
};

FAQItem _$FAQItemFromJson(Map<String, dynamic> json) => FAQItem(
  id: (json['id'] as num).toInt(),
  question: json['question'] as String,
  answer: json['answer'] as String,
  visibilityOrder: (json['visibilityOrder'] as num).toInt(),
);

Map<String, dynamic> _$FAQItemToJson(FAQItem instance) => <String, dynamic>{
  'id': instance.id,
  'question': instance.question,
  'answer': instance.answer,
  'visibilityOrder': instance.visibilityOrder,
};
