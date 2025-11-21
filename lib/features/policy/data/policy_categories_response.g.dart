// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_categories_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PolicyCategoriesResponse _$PolicyCategoriesResponseFromJson(
  Map<String, dynamic> json,
) => PolicyCategoriesResponse(
  success: json['success'] as bool,
  timestamp: json['timestamp'] as String,
  message: json['message'] as String,
  data: PolicyCategoriesData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PolicyCategoriesResponseToJson(
  PolicyCategoriesResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'timestamp': instance.timestamp,
  'message': instance.message,
  'data': instance.data,
};

PolicyCategoriesData _$PolicyCategoriesDataFromJson(
  Map<String, dynamic> json,
) => PolicyCategoriesData(
  categories: (json['categories'] as List<dynamic>)
      .map((e) => PolicyCategory.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PolicyCategoriesDataToJson(
  PolicyCategoriesData instance,
) => <String, dynamic>{'categories': instance.categories};

PolicyCategory _$PolicyCategoryFromJson(Map<String, dynamic> json) =>
    PolicyCategory(
      id: (json['id'] as num).toInt(),
      serviceClassName: json['serviceClassName'] as String,
      image: json['image'] as String,
      color: json['color'] as String,
      providerCategoryId: (json['providerCategoryId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PolicyCategoryToJson(PolicyCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serviceClassName': instance.serviceClassName,
      'image': instance.image,
      'color': instance.color,
      'providerCategoryId': instance.providerCategoryId,
    };
