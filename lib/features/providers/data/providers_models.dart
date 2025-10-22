import 'package:json_annotation/json_annotation.dart';

part 'providers_models.g.dart';

@JsonSerializable(explicitToJson: true)
class ProvidersResponse {
  final bool success;
  final String? timestamp;
  final String? message;
  final ProvidersData? data;

  ProvidersResponse({
    required this.success,
    this.timestamp,
    this.message,
    this.data,
  });

  factory ProvidersResponse.fromJson(Map<String, dynamic> json) => _$ProvidersResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ProvidersResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ProvidersData {
  final List<ProviderItem> providers;
  final Pagination pagination;
  final String? searchTerm;

  ProvidersData({
    required this.providers,
    required this.pagination,
    this.searchTerm,
  });

  factory ProvidersData.fromJson(Map<String, dynamic> json) => _$ProvidersDataFromJson(json);
  Map<String, dynamic> toJson() => _$ProvidersDataToJson(this);
}

@JsonSerializable()
class ProviderItem {
  final int id;
  final String? logo;
  final String name;
  final String? categoryName;
  final int? categoryId;

  ProviderItem({
    required this.id,
    this.logo,
    required this.name,
    this.categoryName,
    this.categoryId,
  });

  factory ProviderItem.fromJson(Map<String, dynamic> json) => _$ProviderItemFromJson(json);
  Map<String, dynamic> toJson() => _$ProviderItemToJson(this);
}

@JsonSerializable()
class Pagination {
  final int currentPage;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  Pagination({
    required this.currentPage,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => _$PaginationFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}


