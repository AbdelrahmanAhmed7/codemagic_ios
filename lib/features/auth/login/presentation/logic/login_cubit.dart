import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/auth/login/domain/login_repository.dart';

part 'login_state.dart';
part 'login_cubit.freezed.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository _repository;

  LoginCubit(this._repository) : super(const LoginState.initial());

  Future<void> submit({required String identifier, required String password}) async {
    emit(const LoginState.loading());
    final ApiResult<void> result = await _repository.login(
      identifier: identifier,
      password: password,
    );

    result.when(
      success: (_) => emit(const LoginState.success()),
      failure: (message) => emit(LoginState.error(message)),
    );
  }
}


