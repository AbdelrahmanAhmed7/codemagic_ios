import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:mediconsult/core/network/api_constants.dart';
import 'package:mediconsult/features/refund/data/refund_request_models.dart';
import 'package:mediconsult/features/refund/data/refund_types_reasons_models.dart';
import 'package:mediconsult/features/refund/data/refund_list_models.dart';
import 'package:mediconsult/features/approval_request/data/approvals_models.dart';

part 'refund_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class RefundApiService {
  factory RefundApiService(Dio dio, {String baseUrl}) = _RefundApiService;

  @POST("{lang}/Refund/Create")
  @MultiPart()
  Future<RefundRequestResponse> createRefundRequest(
    @Path("lang") String lang,
    @Part(name: "memberId") int memberId,
    @Part(name: "refundTypeId") int refundTypeId,
    @Part(name: "refundReasonId") int refundReasonId,
    @Part(name: "totalAmount") double amount,
    @Part(name: "refundDate") String refundDate,
    @Part(name: "providerName") String providerName,
    @Part(name: "notes") String? notes,
    @Part() List<MultipartFile> attachments,
  );

  @GET("{lang}/Refund/GetRefundTypes")
  Future<RefundTypesResponse> getRefundTypes(
    @Path("lang") String lang,
  );

  @GET("{lang}/Refund/GetRefundReasons")
  Future<RefundReasonsResponse> getRefundReasons(
    @Path("lang") String lang,
  );

  @GET("{lang}/Refund/GetRefunds")
  Future<RefundListResponse> getRefunds(
    @Path("lang") String lang,
    @Query("page") int page,
    @Query("pageSize") int pageSize,
    @Query("status") String status,
  );

  @GET("{lang}/Refund/GetRefundPDF/{refundId}")
  Future<ApprovalPdfResponse> getRefundPdf(
    @Path("lang") String lang,
    @Path("refundId") int refundId,
  );
}