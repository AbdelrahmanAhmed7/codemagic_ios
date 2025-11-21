import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/core/network/api_error_handler.dart';
import 'package:mediconsult/features/network/data/city_response_model.dart';
import 'package:mediconsult/features/network/data/government_response_model.dart';
import 'package:mediconsult/features/network/data/network_category_response_model.dart';
import 'package:mediconsult/features/network/data/network_provider_response_model.dart';
import 'package:mediconsult/features/network/service/network_api_service.dart';

class NetworkRepository {
  final NetworkApiService _apiService;
  
  NetworkRepository(this._apiService);

  /// Get all network categories
  Future<ApiResult<NetworkCategoryResponse>> getCategories(String lang) async {
    try {
      final response = await _apiService.getCategories(lang);
      if (response.success == true) {
        return ApiResult.success(response);
      } else {
        return ApiResult.failure(response.message);
      }
    } catch (error) {
      final errorMessage = ErrorHandler.handle(error);
      return ApiResult.failure(errorMessage);
    }
  }

  /// Search for network providers with filters
  Future<ApiResult<NetworkProviderResponse>> searchProviders(
    String lang, {
    String? searchKey,
    int? categoryId,
    int? governmentId,
    int? cityId,
    double? latitude,
    double? longitude,
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await _apiService.searchProviders(
        lang,
        searchKey: searchKey,
        categoryId: categoryId,
        governmentId: governmentId,
        cityId: cityId,
        latitude: latitude,
        longitude: longitude,
        page: page,
        pageSize: pageSize,
      );
      
      if (response.success == true) {
        return ApiResult.success(response);
      } else {
        return ApiResult.failure(response.message);
      }
    } catch (error) {
      final errorMessage = ErrorHandler.handle(error);
      return ApiResult.failure(errorMessage);
    }
  }

  /// Get all governments
  Future<ApiResult<GovernmentResponse>> getGovernments(
    String lang, {
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await _apiService.getGovernments(
        lang,
        page: page,
        pageSize: pageSize,
      );
      
      if (response.success == true) {
        return ApiResult.success(response);
      } else {
        return ApiResult.failure(response.message);
      }
    } catch (error) {
      final errorMessage = ErrorHandler.handle(error);
      return ApiResult.failure(errorMessage);
    }
  }

  /// Get cities by government ID
  Future<ApiResult<CityResponse>> getCitiesByGovernment(
    String lang, {
    int? governmentId,
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await _apiService.getCitiesByGovernment(
        lang,
        governmentId: governmentId,
        page: page,
        pageSize: pageSize,
      );
      
      if (response.success == true) {
        return ApiResult.success(response);
      } else {
        return ApiResult.failure(response.message);
      }
    } catch (error) {
      final errorMessage = ErrorHandler.handle(error);
      return ApiResult.failure(errorMessage);
    }
  }
}
