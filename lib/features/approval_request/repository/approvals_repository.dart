import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/core/network/api_error_handler.dart';
import 'package:mediconsult/features/approval_request/data/approvals_models.dart';
import 'package:mediconsult/features/approval_request/service/approval_request_api_service.dart';

class ApprovalsRepository {
  final ApprovalRequestApiService _apiService;
  ApprovalsRepository(this._apiService);

  Future<ApiResult<ApprovalsResponse>> getApprovals({
    required String lang,
    required String status,
    required int page,
    required int pageSize,
    String? key,
  }) async {
    try {
      final response = await _apiService.getApprovals(lang, status, page, pageSize, key);
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

  Future<ApiResult<ApprovalPdfResponse>> getApprovalPdf({
    required String lang,
    required int approvalId,
  }) async {
    try {
      final response = await _apiService.getApprovalPdf(lang, approvalId)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Request timeout'),
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


