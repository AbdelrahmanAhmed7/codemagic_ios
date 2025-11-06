import 'package:json_annotation/json_annotation.dart';

part 'policy_categories_response.g.dart';

@JsonSerializable()
class PolicyCategoriesResponse {
  final bool success;
  final String timestamp;
  final String message;
  final PolicyCategoriesData data;

  PolicyCategoriesResponse({
    required this.success,
    required this.timestamp,
    required this.message,
    required this.data,
  });

  factory PolicyCategoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$PolicyCategoriesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PolicyCategoriesResponseToJson(this);
}

@JsonSerializable()
class PolicyCategoriesData {
  final List<PolicyCategory> categories;

  PolicyCategoriesData({required this.categories});

  factory PolicyCategoriesData.fromJson(Map<String, dynamic> json) =>
      _$PolicyCategoriesDataFromJson(json);

  Map<String, dynamic> toJson() => _$PolicyCategoriesDataToJson(this);
}

@JsonSerializable()
class PolicyCategory {
  final int id;
  final String serviceClassName;
  final String image;
  final String color;
  final int? providerCategoryId;

  PolicyCategory({
    required this.id,
    required this.serviceClassName,
    required this.image,
    required this.color,
    this.providerCategoryId,
  });

  factory PolicyCategory.fromJson(Map<String, dynamic> json) =>
      _$PolicyCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$PolicyCategoryToJson(this);
}
