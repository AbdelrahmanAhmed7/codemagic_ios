import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/core/network/save_user_token.dart';
import 'package:mediconsult/core/services/firebase_token_service.dart';
import 'package:mediconsult/features/auth/signup/data/register_request_model.dart';
import 'package:mediconsult/features/auth/signup/presentation/logic/signup_state.dart';
import 'package:mediconsult/features/auth/signup/repository/register_repository.dart';

class SignupCubit extends Cubit<SignupState> {
  final RegisterRepository _registerRepository;
  SignupCubit(this._registerRepository) : super(const SignupState.initial());

  Future<void> signup(
    String cardNo,
    String nationalId,
    String phoneNumber,
    String password,
    String confirmPassword,
    String lang,
  ) async {
    emit(const SignupState.loading());
    final request = RegisterRequestModel(
      cardNo: cardNo,
      nationalId: nationalId,
      phoneNumber: phoneNumber,
      password: password,
      confirmPassword: confirmPassword,
    );
    final response = await _registerRepository.register(request, lang);
    response.when(
      success: (response) async {
        await saveUserToken(response.data!.token);
        emit(SignupState.success(response));
        
        // Send Firebase token to backend (non-blocking)
        FirebaseTokenService.instance.sendTokenToBackend(lang);
      },
      failure: (message) {
        emit(SignupState.failed(error: message));
      },
    );
  }
}