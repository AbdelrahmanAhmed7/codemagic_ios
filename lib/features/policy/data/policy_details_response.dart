import 'package:json_annotation/json_annotation.dart';

part 'policy_details_response.g.dart';

@JsonSerializable()
class PolicyDetailsResponse {
  final bool success;
  final String timestamp;
  final String message;
  final PolicyDetailsData data;

  PolicyDetailsResponse({
    required this.success,
    required this.timestamp,
    required this.message,
    required this.data,
  });

  factory PolicyDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$PolicyDetailsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PolicyDetailsResponseToJson(this);
}

@JsonSerializable()
class PolicyDetailsData {
  final num slCopayment;
  final num slLimit;
  final num slServiceCount;
  final int? providerCategoryId;
  final List<PolicyProviderItem> providers;

  PolicyDetailsData({
    required this.slCopayment,
    required this.slLimit,
    required this.slServiceCount,
    required this.providerCategoryId,
    required this.providers,
  });

  factory PolicyDetailsData.fromJson(Map<String, dynamic> json) =>
      _$PolicyDetailsDataFromJson(json);
  Map<String, dynamic> toJson() => _$PolicyDetailsDataToJson(this);
}

@JsonSerializable()
class PolicyProviderItem {
  final int providerId;
  final String providerName;
  final String logo;
  final num copaymentPercent;

  PolicyProviderItem({
    required this.providerId,
    required this.providerName,
    required this.logo,
    required this.copaymentPercent,
  });

  factory PolicyProviderItem.fromJson(Map<String, dynamic> json) =>
      _$PolicyProviderItemFromJson(json);
  Map<String, dynamic> toJson() => _$PolicyProviderItemToJson(this);
}


