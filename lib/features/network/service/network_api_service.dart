import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:mediconsult/core/network/api_constants.dart';
import 'package:mediconsult/features/network/data/network_category_response_model.dart';
import 'package:mediconsult/features/network/data/network_provider_response_model.dart';
import 'package:mediconsult/features/network/data/government_response_model.dart';
import 'package:mediconsult/features/network/data/city_response_model.dart';

part 'network_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class NetworkApiService {
  factory NetworkApiService(Dio dio, {String baseUrl}) = _NetworkApiService;

  /// Get all network categories
  @GET('/{lang}/Network/GetCategories')
  Future<NetworkCategoryResponse> getCategories(
    @Path('lang') String lang,
  );

  /// Search for network providers with filters
  @GET('/{lang}/Network/GetNetwork')
  Future<NetworkProviderResponse> searchProviders(
    @Path('lang') String lang, {
    @Query("search") String? searchKey,
    @Query("categoryId") int? categoryId,
    @Query("governmentId") int? governmentId,
    @Query("cityId") int? cityId,
    @Query("latitude") double? latitude,
    @Query("longitude") double? longitude,
    @Query("page") int? page,
    @Query("pageSize") int? pageSize,
  });

  /// Get all governments
  @GET('/{lang}/Network/GetGovernments')
  Future<GovernmentResponse> getGovernments(
    @Path('lang') String lang, {
    @Query("page") int? page,
    @Query("pageSize") int? pageSize,
  });

  /// Get cities by government ID
  @GET('/{lang}/Network/GetCities')
  Future<CityResponse> getCitiesByGovernment(
    @Path('lang') String lang, {
    @Query("governmentId") int? governmentId,
    @Query("page") int? page,
    @Query("pageSize") int? pageSize,
  });
}
