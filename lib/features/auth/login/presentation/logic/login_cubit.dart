import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/core/constants/constants.dart';
import 'package:mediconsult/core/helpers/shared_pref_helper.dart';
import 'package:mediconsult/core/network/dio_factory.dart';
import 'package:mediconsult/features/auth/login/data/login_request_model.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/login_state.dart';
import 'package:mediconsult/features/auth/login/repository/login_repository.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository _loginRepository;
  LoginCubit(this._loginRepository) : super(const LoginState.initial());

  Future<void> login(String cardNo, String password, String lang) async {
    emit(const LoginState.loading());
    final request = LoginRequestModel(cardNo: cardNo, password: password);
    final response = await _loginRepository.login(request, lang);
    response.when(
      success: (response) async{
        await saveUserToken(response.data!.token);
        emit(LoginState.success(response));
      },
      failure: (message) {
        emit(LoginState.failed(error: message));
      },
    );
  }
  Future<void> saveUserToken(String token) async {
    await SharedPrefHelper.setSecuredString(SharedPrefKeys.userToken, token);
    DioFactory.setTokenIntoHeaderAfterLogin(token);
  }
}