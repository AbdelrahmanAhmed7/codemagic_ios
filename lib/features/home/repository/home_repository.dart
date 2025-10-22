import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/core/network/api_error_handler.dart';
import 'package:mediconsult/features/home/data/home_response_model.dart';
import 'package:mediconsult/features/home/service/home_api_service.dart';

class HomeRepository {
  final HomeApiService _apiService;

  HomeRepository(this._apiService);

  Future<ApiResult<HomeResponse>> getHomeInfo(String lang) async {
    try {
      final response = await _apiService.getHomeInfo(lang);

      if (response.success == true && response.data != null) {
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