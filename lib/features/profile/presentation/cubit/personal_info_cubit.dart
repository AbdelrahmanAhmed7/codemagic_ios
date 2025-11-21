import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/cache/cache_service.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/profile/data/personal_info_response.dart';
import 'package:mediconsult/features/profile/presentation/cubit/personal_info_state.dart';
import 'package:mediconsult/features/profile/repository/profile_repository.dart';

class PersonalInfoCubit extends Cubit<PersonalInfoState> {
  final ProfileRepository _repository;
  PersonalInfoCubit(this._repository) : super(const PersonalInfoState.initial());

  Future<void> load({required String lang, bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await CacheService.getCachedPersonalInfo();
      if (cached != null) {
        emit(PersonalInfoState.loaded(PersonalInfoResponse.fromJson(cached)));
        unawaited(_fetchAndCache(lang));
        return;
      }
    }
    emit(const PersonalInfoState.loading());
    await _fetchAndCache(lang);
  }

  Future<void> _fetchAndCache(String lang) async {
    final result = await _repository.getPersonalInfo(lang);
    result.when(
      success: (data) async {
        await CacheService.cachePersonalInfo(data.toJson());
        emit(PersonalInfoState.loaded(data));
      },
      failure: (message) async {
        final cached = await CacheService.getCachedPersonalInfo();
        if (cached != null) {
          emit(PersonalInfoState.loaded(PersonalInfoResponse.fromJson(cached)));
        } else {
          emit(PersonalInfoState.failed(message));
        }
      },
    );
  }
}