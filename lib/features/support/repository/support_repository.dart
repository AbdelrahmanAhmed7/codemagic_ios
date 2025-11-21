import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/core/network/api_error_handler.dart';
import 'package:mediconsult/features/support/data/contacts_response_model.dart';
import 'package:mediconsult/features/support/data/faq_response_model.dart';
import 'package:mediconsult/features/support/service/support_api_service.dart';

class SupportRepository {
  final SupportApiService _apiService;

  SupportRepository(this._apiService);

  Future<ApiResult<ContactsResponse>> getContacts(String lang) async {
    try {
      final response = await _apiService.getContacts(lang);
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

  Future<ApiResult<FAQResponse>> getFaqs(String lang) async {
    try {
      final response = await _apiService.getFaqs(lang);
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


