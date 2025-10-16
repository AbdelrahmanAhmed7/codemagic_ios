import 'package:equatable/equatable.dart';

sealed class ApprovalState extends Equatable {
  const ApprovalState();

  @override
  List<Object?> get props => [];
}

class ApprovalLoading extends ApprovalState {
  const ApprovalLoading();
}

class ApprovalEmpty extends ApprovalState {
  const ApprovalEmpty();
}

class ApprovalFormMode extends ApprovalState {
  const ApprovalFormMode();
}

class ApprovalError extends ApprovalState {
  const ApprovalError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}


