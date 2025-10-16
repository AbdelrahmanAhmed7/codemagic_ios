import 'package:flutter_bloc/flutter_bloc.dart';
import 'approval_state.dart';

class ApprovalCubit extends Cubit<ApprovalState> {
  ApprovalCubit() : super(const ApprovalEmpty());

  Future<void> loadHistory() async {
    emit(const ApprovalLoading());
    // TODO: plug API here
    await Future.delayed(const Duration(milliseconds: 300));
    emit(const ApprovalEmpty());
  }

  void openForm() => emit(const ApprovalFormMode());
  void closeForm() => emit(const ApprovalEmpty());
}


