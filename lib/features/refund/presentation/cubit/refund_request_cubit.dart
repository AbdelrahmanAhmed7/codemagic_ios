import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/refund/presentation/cubit/refund_request_state.dart';
import 'package:mediconsult/features/refund/repository/refund_repository.dart';
import 'package:mediconsult/core/services/firebase_crashlytics_service.dart';

class RefundRequestCubit extends Cubit<RefundRequestState> {
  final RefundRepository _repository;
  
  RefundRequestCubit(this._repository) : super(const RefundRequestState.initial());

  Future<void> createRefundRequest({
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
    emit(const RefundRequestState.loading());

    final result = await _repository.createRefundRequest(
      lang: lang,
      memberId: memberId,
      refundTypeId: refundTypeId,
      refundReasonId: refundReasonId,
      amount: amount,
      serviceDate: serviceDate,
      providerName: providerName,
      notes: notes,
      attachmentPaths: attachmentPaths,
    );

    result.when(
      success: (response) {
        emit(RefundRequestState.success(response.data!));
      },
      failure: (message) {
        // تسجيل فشل طلب الاسترداد
        FirebaseCrashlyticsService.instance.recordError(
          exception: 'Refund Request Failed: $message',
          reason: 'Failed to create refund request',
          information: [
            'Member ID: $memberId',
            'Refund Type: $refundTypeId',
            'Amount: $amount',
            'Provider: $providerName',
          ],
        );
        
        emit(RefundRequestState.failed(message));
      },
    );
  }

  void reset() {
    emit(const RefundRequestState.initial());
  }
}
