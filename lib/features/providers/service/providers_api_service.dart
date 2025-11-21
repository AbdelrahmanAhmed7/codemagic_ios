import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:mediconsult/core/network/api_constants.dart';
import 'package:mediconsult/features/providers/data/providers_models.dart';

part 'providers_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ProvidersApiService {
  factory ProvidersApiService(Dio dio, {String baseUrl}) = _ProvidersApiService;

  // GET /{lang}/Providers with pagination and search
  @GET("{lang}/Providers/GetProviders")
  Future<ProvidersResponse> getProviders(
    @Path("lang") String lang,
    @Query("page") int page,
    @Query("pageSize") int pageSize,
    @Query("search") String? search,
    // Optional filters
    @Query("categoryId") int? categoryId,
  );
}


