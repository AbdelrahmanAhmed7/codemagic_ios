import 'package:dio/dio.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/core/network/api_error_handler.dart';
import 'package:mediconsult/features/approval_request/data/approval_request_models.dart';
import 'package:mediconsult/features/approval_request/service/approval_request_api_service.dart';

class ApprovalRequestRepository {
  final ApprovalRequestApiService _apiService;

  ApprovalRequestRepository(this._apiService);

  Future<ApiResult<ApprovalRequestResponse>> createApprovalRequest({
    required String lang,
    required int memberId,
    required int providerId,
    String? notes,
    required List<String> attachmentPaths,
  }) async {
    try {
      // Convert file paths to MultipartFile
      final List<MultipartFile> attachments = [];
      for (String path in attachmentPaths) {
        final file = await MultipartFile.fromFile(path);
        attachments.add(file);
      }

      final response = await _apiService.createApprovalRequest(
        lang,
        memberId,
        providerId,
        notes,
        attachments,
      );

      if (response.success == true) {
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
