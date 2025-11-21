// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PolicyDetailsResponse _$PolicyDetailsResponseFromJson(
  Map<String, dynamic> json,
) => PolicyDetailsResponse(
  success: json['success'] as bool,
  timestamp: json['timestamp'] as String,
  message: json['message'] as String,
  data: PolicyDetailsData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PolicyDetailsResponseToJson(
  PolicyDetailsResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'timestamp': instance.timestamp,
  'message': instance.message,
  'data': instance.data,
};

PolicyDetailsData _$PolicyDetailsDataFromJson(Map<String, dynamic> json) =>
    PolicyDetailsData(
      slCopayment: json['slCopayment'] as num,
      slLimit: json['slLimit'] as num,
      slServiceCount: json['slServiceCount'] as num,
      providerCategoryId: (json['providerCategoryId'] as num?)?.toInt(),
      providers: (json['providers'] as List<dynamic>)
          .map((e) => PolicyProviderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PolicyDetailsDataToJson(PolicyDetailsData instance) =>
    <String, dynamic>{
      'slCopayment': instance.slCopayment,
      'slLimit': instance.slLimit,
      'slServiceCount': instance.slServiceCount,
      'providerCategoryId': instance.providerCategoryId,
      'providers': instance.providers,
    };

PolicyProviderItem _$PolicyProviderItemFromJson(Map<String, dynamic> json) =>
    PolicyProviderItem(
      providerId: (json['providerId'] as num).toInt(),
      providerName: json['providerName'] as String,
      logo: json['logo'] as String,
      copaymentPercent: json['copaymentPercent'] as num,
    );

Map<String, dynamic> _$PolicyProviderItemToJson(PolicyProviderItem instance) =>
    <String, dynamic>{
      'providerId': instance.providerId,
      'providerName': instance.providerName,
      'logo': instance.logo,
      'copaymentPercent': instance.copaymentPercent,
    };
