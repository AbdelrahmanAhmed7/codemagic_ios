import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/cache/cache_service.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/core/services/notification_badge_service.dart';
import 'package:mediconsult/features/home/presentation/cubit/cubit/home_state.dart';
import 'package:mediconsult/features/home/repository/home_repository.dart';
import 'package:mediconsult/core/services/firebase_crashlytics_service.dart';

class HomeCubit extends Cubit<HomeCubitState> {
  final HomeRepository _homeRepository;
  HomeCubit(this._homeRepository) : super(HomeCubitState.initial());

  Future<void> getHomeInfo(String lang, {bool forceRefresh = false}) async {
    try {
      // IF CACHE IS VALID
      if (!forceRefresh) {
        final cachedData = await CacheService.getCachedHomeData();
        if (cachedData != null) {
          // Update notification badge count from cache
          NotificationBadgeService.instance.setCount(cachedData.data!.notificationsCount);
          emit(HomeCubitState.loaded(cachedData));

          // IF CACHE IS EXPIRED
          unawaited(_fetchAndCacheData(lang));
          return;
        }
      }

      // 
      emit(HomeCubitState.loading());
      await _fetchAndCacheData(lang);
    } catch (e, stackTrace) {
      // تسجيل أخطاء تحميل بيانات الصفحة الرئيسية
      FirebaseCrashlyticsService.instance.recordError(
        exception: e,
        stackTrace: stackTrace,
        reason: 'Failed to load home data',
        information: ['Language: $lang', 'Force Refresh: $forceRefresh'],
      );
      
      emit(HomeCubitState.failed(e.toString()));
    }
  }

  Future<void> _fetchAndCacheData(String lang) async {
    final response = await _homeRepository.getHomeInfo(lang);
    response.when(
      success: (data) async {
        await CacheService.cacheHomeData(data);
        // Update notification badge count
        NotificationBadgeService.instance.setCount(data.data!.notificationsCount);
        emit(HomeCubitState.loaded(data));
      },
      failure: (message) async {
        // Try to get cached data if API fails
        final cachedData = await CacheService.getCachedHomeData();
        if (cachedData != null) {
          // Update notification badge count from cache
          NotificationBadgeService.instance.setCount(cachedData.data!.notificationsCount);
          emit(HomeCubitState.loaded(cachedData));
        } else {
          emit(HomeCubitState.failed(message));
        }
      },
    );
  }

  Future<void> refreshHomeInfo(String lang) async {
    await getHomeInfo(lang, forceRefresh: true);
  }

  Future<void> retry(String lang) async {
    // Don't force refresh on retry, allow cache fallback
    await getHomeInfo(lang, forceRefresh: false);
  }
}
