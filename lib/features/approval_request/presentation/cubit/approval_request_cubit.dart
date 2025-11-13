import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/approval_request/presentation/cubit/approval_request_state.dart';
import 'package:mediconsult/features/approval_request/repository/approval_request_repository.dart';
import 'package:mediconsult/core/services/firebase_crashlytics_service.dart';

class ApprovalRequestCubit extends Cubit<ApprovalRequestState> {
  final ApprovalRequestRepository _repository;
  
  ApprovalRequestCubit(this._repository) : super(const ApprovalRequestState.initial());

  Future<void> createApprovalRequest({
    required String lang,
    required int memberId,
    required int providerId,
    String? notes,
    required List<String> attachmentPaths,
  }) async {
    emit(const ApprovalRequestState.loading());

    final result = await _repository.createApprovalRequest(
      lang: lang,
      memberId: memberId,
      providerId: providerId,
      notes: notes,
      attachmentPaths: attachmentPaths,
    );

    result.when(
      success: (response) {
        emit(ApprovalRequestState.success(response.data!));
      },
      failure: (message) {
        // تسجيل فشل طلب الموافقة
        FirebaseCrashlyticsService.instance.recordError(
          exception: 'Approval Request Failed: $message',
          reason: 'Failed to create approval request',
          information: [
            'Member ID: $memberId',
            'Provider ID: $providerId',
            'Language: $lang',
          ],
        );
        
        emit(ApprovalRequestState.failed(message));
      },
    );
  }

  void reset() {
    emit(const ApprovalRequestState.initial());
  }
}
