import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/refund/data/refund_types_reasons_models.dart';
import 'package:mediconsult/features/refund/repository/refund_repository.dart';

class RefundReasonsCubit extends Cubit<RefundReasonsState> {
  final RefundRepository _repository;

  RefundReasonsCubit(this._repository) : super(const RefundReasonsInitial());

  Future<void> loadRefundReasons(String lang) async {
    emit(const RefundReasonsLoading());

    final result = await _repository.getRefundReasons(lang: lang);

    result.when(
      success: (response) {
        if (response.data != null && response.data!.refundReasons.isNotEmpty) {
          emit(RefundReasonsLoaded(response.data!.refundReasons));
        } else {
          emit(const RefundReasonsFailed('No refund reasons available'));
        }
      },
      failure: (message) {
        emit(RefundReasonsFailed(message));
      },
    );
  }
}

// Simple state without freezed
abstract class RefundReasonsState {
  const RefundReasonsState();
}

class RefundReasonsInitial extends RefundReasonsState {
  const RefundReasonsInitial();
}

class RefundReasonsLoading extends RefundReasonsState {
  const RefundReasonsLoading();
}

class RefundReasonsLoaded extends RefundReasonsState {
  final List<RefundReason> reasons;
  const RefundReasonsLoaded(this.reasons);
}

class RefundReasonsFailed extends RefundReasonsState {
  final String message;
  const RefundReasonsFailed(this.message);
}
