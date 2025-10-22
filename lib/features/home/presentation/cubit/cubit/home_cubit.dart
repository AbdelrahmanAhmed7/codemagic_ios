import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/cache/cache_service.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/home/presentation/cubit/cubit/home_state.dart';
import 'package:mediconsult/features/home/repository/home_repository.dart';

class HomeCubit extends Cubit<HomeCubitState> {
  final HomeRepository _homeRepository;
  HomeCubit(this._homeRepository) : super(HomeCubitState.initial());

  Future<void> getHomeInfo(String lang, {bool forceRefresh = false}) async {
    try {
      // IF CACHE IS VALID
      if (!forceRefresh) {
        final cachedData = await CacheService.getCachedHomeData();
        if (cachedData != null) {
          emit(HomeCubitState.loaded(cachedData));

          // IF CACHE IS EXPIRED
          unawaited(_fetchAndCacheData(lang));
          return;
        }
      }

      // 
      emit(HomeCubitState.loading());
      await _fetchAndCacheData(lang);
    } catch (e) {
      emit(HomeCubitState.failed(e.toString()));
    }
  }

  Future<void> _fetchAndCacheData(String lang) async {
    final response = await _homeRepository.getHomeInfo(lang);
    response.when(
      success: (data) async {
        await CacheService.cacheHomeData(data);
        emit(HomeCubitState.loaded(data));
      },
      failure: (message) {
        emit(HomeCubitState.failed(message));
      },
    );
  }

  Future<void> refreshHomeInfo(String lang) async {
    await getHomeInfo(lang, forceRefresh: true);
  }

  Future<void> retry(String lang) async {
    await getHomeInfo(lang, forceRefresh: true);
  }
}
