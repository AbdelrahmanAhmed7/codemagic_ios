import 'package:dio/dio.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/core/network/api_error_handler.dart';
import 'package:mediconsult/features/refund/data/refund_request_models.dart';
import 'package:mediconsult/features/refund/data/refund_types_reasons_models.dart';
import 'package:mediconsult/features/refund/data/refund_list_models.dart';
import 'package:mediconsult/features/refund/service/refund_api_service.dart';
import 'package:mediconsult/features/approval_request/data/approvals_models.dart';

class RefundRepository {
  final RefundApiService _apiService;

  RefundRepository(this._apiService);

  Future<ApiResult<RefundRequestResponse>> createRefundRequest({
    required String lang,
    required int memberId,
    required int refundTypeId,
    required int refundReasonId,
    required double amount,
    required String serviceDate,
    required String providerName,
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

      final response = await _apiService.createRefundRequest(
        lang,
        memberId,
        refundTypeId,
        refundReasonId,
        amount,
        serviceDate,
        providerName,
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

  Future<ApiResult<RefundTypesResponse>> getRefundTypes({
    required String lang,
  }) async {
    try {
      final response = await _apiService.getRefundTypes(lang);
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

  Future<ApiResult<RefundReasonsResponse>> getRefundReasons({
    required String lang,
  }) async {
    try {
      final response = await _apiService.getRefundReasons(lang);
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

  Future<ApiResult<RefundListResponse>> getRefunds({
    required String lang,
    required int page,
    required int pageSize,
    required String status,
  }) async {
    try {
      final response = await _apiService.getRefunds(
        lang,
        page,
        pageSize,
        status,
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

  Future<ApiResult<ApprovalPdfResponse>> getRefundPdf({
    required String lang,
    required int refundId,
  }) async {
    try {
      final response = await _apiService.getRefundPdf(lang, refundId)
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
