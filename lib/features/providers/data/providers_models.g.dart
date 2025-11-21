// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProvidersResponse _$ProvidersResponseFromJson(Map<String, dynamic> json) =>
    ProvidersResponse(
      success: json['success'] as bool,
      timestamp: json['timestamp'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : ProvidersData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProvidersResponseToJson(ProvidersResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'timestamp': instance.timestamp,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };

ProvidersData _$ProvidersDataFromJson(Map<String, dynamic> json) =>
    ProvidersData(
      providers: (json['providers'] as List<dynamic>)
          .map((e) => ProviderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
      searchTerm: json['searchTerm'] as String?,
    );

Map<String, dynamic> _$ProvidersDataToJson(ProvidersData instance) =>
    <String, dynamic>{
      'providers': instance.providers.map((e) => e.toJson()).toList(),
      'pagination': instance.pagination.toJson(),
      'searchTerm': instance.searchTerm,
    };

ProviderItem _$ProviderItemFromJson(Map<String, dynamic> json) => ProviderItem(
  id: (json['id'] as num).toInt(),
  logo: json['logo'] as String?,
  name: json['name'] as String,
  categoryName: json['categoryName'] as String?,
  categoryId: (json['categoryId'] as num?)?.toInt(),
);

Map<String, dynamic> _$ProviderItemToJson(ProviderItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'logo': instance.logo,
      'name': instance.name,
      'categoryName': instance.categoryName,
      'categoryId': instance.categoryId,
    };

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
  currentPage: (json['currentPage'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  totalCount: (json['totalCount'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  hasNextPage: json['hasNextPage'] as bool,
  hasPreviousPage: json['hasPreviousPage'] as bool,
);

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'pageSize': instance.pageSize,
      'totalCount': instance.totalCount,
      'totalPages': instance.totalPages,
      'hasNextPage': instance.hasNextPage,
      'hasPreviousPage': instance.hasPreviousPage,
    };
