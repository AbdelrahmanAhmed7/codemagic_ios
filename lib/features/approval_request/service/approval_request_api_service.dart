import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:mediconsult/core/network/api_constants.dart';
import 'package:mediconsult/features/approval_request/data/approval_request_models.dart';
import 'package:mediconsult/features/approval_request/data/approvals_models.dart';

part 'approval_request_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ApprovalRequestApiService {
  factory ApprovalRequestApiService(Dio dio, {String baseUrl}) = _ApprovalRequestApiService;

  @POST("{lang}/Approval/Create")
  @MultiPart()
  Future<ApprovalRequestResponse> createApprovalRequest(
    @Path("lang") String lang,
    @Part(name: "memberId") int memberId,
    @Part(name: "providerId") int providerId,
    @Part(name: "notes") String? notes,
    @Part() List<MultipartFile> attachments,
  );

  @GET("{lang}/Approval/GetApprovals")
  Future<ApprovalsResponse> getApprovals(
    @Path("lang") String lang,
    @Query("status") String status,
    @Query("page") int page,
    @Query("pageSize") int pageSize,
    @Query("key") String? key,
  );

  @GET("{lang}/Approval/GetApprovalPDF/{approvalId}")
  Future<ApprovalPdfResponse> getApprovalPdf(
    @Path("lang") String lang,
    @Path("approvalId") int approvalId,
  );
}
