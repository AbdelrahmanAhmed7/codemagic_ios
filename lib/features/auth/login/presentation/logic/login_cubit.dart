import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/core/network/save_user_token.dart';
import 'package:mediconsult/core/services/firebase_token_service.dart';
import 'package:mediconsult/features/auth/login/data/login_request_model.dart';
import 'package:mediconsult/features/auth/login/presentation/logic/login_state.dart';
import 'package:mediconsult/features/auth/login/repository/login_repository.dart';
import 'package:mediconsult/core/services/firebase_crashlytics_service.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository _loginRepository;
  LoginCubit(this._loginRepository) : super(const LoginState.initial());

  Future<void> login(String cardNo, String password, String lang) async {
    emit(const LoginState.loading());
    
    try {
      final request = LoginRequestModel(cardNo: cardNo, password: password);
      final response = await _loginRepository.login(request, lang);
      
      response.when(
        success: (response) async {
          await saveUserToken(response.data!.token);
          
          // تعيين معرف المستخدم في Crashlytics
          final userId = response.data!.token; // أو أي معرف مناسب
          await FirebaseCrashlyticsService.instance.setUserId(userId);
          
          emit(LoginState.success(response));
          
          // Send Firebase token to backend (non-blocking)
          FirebaseTokenService.instance.sendTokenToBackend(lang);
        },
        failure: (message) {
          // تسجيل خطأ المصادقة
          FirebaseCrashlyticsService.instance.recordAuthError(
            authMethod: 'card_id',
            errorMessage: message,
            userId: cardNo,
          );
          
          emit(LoginState.failed(error: message));
        },
      );
    } catch (e, stackTrace) {
      // تسجيل الأخطاء غير المتوقعة
      await FirebaseCrashlyticsService.instance.recordError(
        exception: e,
        stackTrace: stackTrace,
        reason: 'Login process failed unexpectedly',
        information: ['Card No: $cardNo', 'Language: $lang'],
      );
      
      emit(const LoginState.failed(error: 'حدث خطأ غير متوقع'));
    }
  }
}
