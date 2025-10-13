import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/auth/signup/domain/signup_repository.dart';

part 'signup_state.dart';
part 'signup_cubit.freezed.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupRepository _repository;

  SignupCubit(this._repository) : super(const SignupState.initial());

  Future<void> requestOtp(String phoneNumber) async {
    emit(const SignupState.loading());
    final ApiResult<void> result = await _repository.requestOtp(phoneNumber: phoneNumber);
    result.when(
      success: (_) => emit(const SignupState.otpRequested()),
      failure: (message) => emit(SignupState.error(message)),
    );
  }

  Future<void> verifyOtp({required String phoneNumber, required String otp}) async {
    emit(const SignupState.loading());
    final ApiResult<void> result = await _repository.verifyOtp(phoneNumber: phoneNumber, otp: otp);
    result.when(
      success: (_) => emit(const SignupState.otpVerified()),
      failure: (message) => emit(SignupState.error(message)),
    );
  }

  Future<void> createAccount({
    required String fullName,
    required String phoneNumber,
    required String password,
  }) async {
    emit(const SignupState.loading());
    final ApiResult<void> result = await _repository.createAccount(
      fullName: fullName,
      phoneNumber: phoneNumber,
      password: password,
    );
    result.when(
      success: (_) => emit(const SignupState.success()),
      failure: (message) => emit(SignupState.error(message)),
    );
  }
}


