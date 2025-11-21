import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/policy/presentation/cubit/get_policy_categories_state.dart';
import 'package:mediconsult/features/policy/repository/get_policy_categories_repo.dart';
import 'package:mediconsult/core/services/firebase_crashlytics_service.dart';

class GetPolicyCategoriesCubit extends Cubit<GetPolicyCategoriesState> {
  final GetPolicyCategoriesRepository _repository;
  GetPolicyCategoriesCubit(this._repository)
    : super(GetPolicyCategoriesState.initial());

  Future<void> getPolicyCategories(String lang) async {
    emit(GetPolicyCategoriesState.loading());
    final response = await _repository.getPolicyCategories(lang);

    response.when(
      success: (data) {
        emit(GetPolicyCategoriesState.loaded(data));
      },
      failure: (message) {
        // تسجيل فشل تحميل فئات البوليسي
        FirebaseCrashlyticsService.instance.recordError(
          exception: 'Policy Categories Load Failed: $message',
          reason: 'Failed to load policy categories',
          information: ['Language: $lang'],
        );
        
        emit(GetPolicyCategoriesState.failed(message));
      },
    );
  }
}
