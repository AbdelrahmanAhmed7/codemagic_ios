import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/core/network/save_user_token.dart';
import 'package:mediconsult/core/services/firebase_token_service.dart';
import 'package:mediconsult/features/auth/signup/data/register_request_model.dart';
import 'package:mediconsult/features/auth/signup/presentation/logic/signup_state.dart';
import 'package:mediconsult/features/auth/signup/repository/register_repository.dart';
import 'package:mediconsult/core/services/firebase_crashlytics_service.dart';

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
    
    try {
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
          
          // تعيين معرف المستخدم في Crashlytics
          final userId = response.data!.token;
          await FirebaseCrashlyticsService.instance.setUserId(userId);
          
          emit(SignupState.success(response));
          
          // Send Firebase token to backend (non-blocking)
          FirebaseTokenService.instance.sendTokenToBackend(lang);
        },
        failure: (message) {
          // تسجيل خطأ التسجيل
          FirebaseCrashlyticsService.instance.recordAuthError(
            authMethod: 'signup',
            errorMessage: message,
            userId: cardNo,
          );
          
          emit(SignupState.failed(error: message));
        },
      );
    } catch (e, stackTrace) {
      // تسجيل الأخطاء غير المتوقعة
      await FirebaseCrashlyticsService.instance.recordError(
        exception: e,
        stackTrace: stackTrace,
        reason: 'Signup process failed unexpectedly',
        information: [
          'Card No: $cardNo',
          'National ID: $nationalId',
          'Phone: $phoneNumber',
          'Language: $lang',
        ],
      );
      
      emit(const SignupState.failed(error: 'حدث خطأ غير متوقع'));
    }
  }
}