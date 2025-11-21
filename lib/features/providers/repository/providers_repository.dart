import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/core/network/api_error_handler.dart';
import 'package:mediconsult/features/providers/data/providers_models.dart';
import 'package:mediconsult/features/providers/service/providers_api_service.dart';

class ProvidersRepository {
  final ProvidersApiService _apiService;

  ProvidersRepository(this._apiService);

  Future<ApiResult<ProvidersResponse>> getProviders({
    required String lang,
    required int page,
    required int pageSize,
    String? search,
    int? categoryId,
  }) async {
    try {
      final response = await _apiService.getProviders(
        lang,
        page,
        pageSize,
        search,
        categoryId,
      );

      if (response.success == true && response.data != null) {
        return ApiResult.success(response);
      } else {
        return ApiResult.failure(response.message ?? 'Unknown error');
      }
    } catch (error) {
      final errorMessage = ErrorHandler.handle(error);
      return ApiResult.failure(errorMessage);
    }
  }
}


