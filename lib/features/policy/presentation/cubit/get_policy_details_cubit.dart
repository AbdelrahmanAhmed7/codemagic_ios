import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/policy/presentation/cubit/get_policy_details_state.dart';
import 'package:mediconsult/features/policy/repository/get_policy_details_repo.dart';
import 'package:mediconsult/core/services/firebase_crashlytics_service.dart';

class GetPolicyDetailsCubit extends Cubit<GetPolicyDetailsState> {
  final GetPolicyDetailsRepository _repository;
  GetPolicyDetailsCubit(this._repository) : super(const GetPolicyDetailsState.initial());

  Future<void> getDetails(String lang, int categoryId) async {
    emit(const GetPolicyDetailsState.loading());
    
    try {
      final response = await _repository.getByCategoryId(lang, categoryId);
      response.when(
        success: (data) => emit(GetPolicyDetailsState.loaded(data)),
        failure: (message) {
          // تسجيل فشل تحميل تفاصيل البوليسي
          FirebaseCrashlyticsService.instance.recordError(
            exception: 'Policy Details Load Failed: $message',
            reason: 'Failed to load policy details',
            information: [
              'Language: $lang',
              'Category ID: $categoryId',
            ],
          );
          
          emit(GetPolicyDetailsState.failed(message));
        },
      );
    } catch (e, stackTrace) {
      // تسجيل الأخطاء غير المتوقعة
      await FirebaseCrashlyticsService.instance.recordError(
        exception: e,
        stackTrace: stackTrace,
        reason: 'Policy details loading failed unexpectedly',
        information: [
          'Language: $lang',
          'Category ID: $categoryId',
        ],
      );
      
      emit(const GetPolicyDetailsState.failed('حدث خطأ غير متوقع'));
    }
  }
}





