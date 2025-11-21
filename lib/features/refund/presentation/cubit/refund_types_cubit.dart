import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/refund/data/refund_types_reasons_models.dart';
import 'package:mediconsult/features/refund/repository/refund_repository.dart';

class RefundTypesCubit extends Cubit<RefundTypesState> {
  final RefundRepository _repository;

  RefundTypesCubit(this._repository) : super(const RefundTypesInitial());

  Future<void> loadRefundTypes(String lang) async {
    emit(const RefundTypesLoading());

    final result = await _repository.getRefundTypes(lang: lang);

    result.when(
      success: (response) {
        if (response.data != null && response.data!.refundTypes.isNotEmpty) {
          emit(RefundTypesLoaded(response.data!.refundTypes));
        } else {
          emit(const RefundTypesFailed('No refund types available'));
        }
      },
      failure: (message) {
        emit(RefundTypesFailed(message));
      },
    );
  }
}

// Simple state without freezed
abstract class RefundTypesState {
  const RefundTypesState();
}

class RefundTypesInitial extends RefundTypesState {
  const RefundTypesInitial();
}

class RefundTypesLoading extends RefundTypesState {
  const RefundTypesLoading();
}

class RefundTypesLoaded extends RefundTypesState {
  final List<RefundType> types;
  const RefundTypesLoaded(this.types);
}

class RefundTypesFailed extends RefundTypesState {
  final String message;
  const RefundTypesFailed(this.message);
}
