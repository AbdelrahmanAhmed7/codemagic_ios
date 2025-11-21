import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/cache/cache_service.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/notifications/data/notification_models.dart';
import 'package:mediconsult/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:mediconsult/features/notifications/repository/notification_repository.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationRepository _repository;
  NotificationsCubit(this._repository) : super(const NotificationsState.initial());

  int _page = 1;
  int _pageSize = 10;
  bool _loadingMore = false;
  final List<NotificationItem> _items = [];

  Future<void> load({
    required String lang,
    int? pageSize,
    bool reset = false,
    bool forceRefresh = false,
  }) async {
    if (reset) {
      _page = 1;
      _items.clear();
    }
    _pageSize = pageSize ?? _pageSize;

    // Try cache for first page only
    if (_page == 1 && !forceRefresh) {
      final cachedData = await CacheService.getCachedNotificationsData();
      if (cachedData != null && cachedData.data != null) {
        final data = cachedData.data!;
        _items.clear();
        _items.addAll(data.notifications);
        emit(NotificationsState.loaded(
          notifications: List.of(_items),
          totalCount: data.totalCount,
          currentPage: data.page,
          totalPages: data.totalPages,
          hasNextPage: data.page < data.totalPages,
          loadingMore: false,
        ));

        // Background refresh
        unawaited(_fetchAndCacheData(lang));
        return;
      }
    }

    if (_page == 1) {
      emit(const NotificationsState.loading());
    } else {
      _loadingMore = true;
      final currentState = state;
      if (currentState is Loaded) {
        emit(currentState.copyWith(loadingMore: true));
      }
    }

    await _fetchAndCacheData(lang);
  }

  Future<void> _fetchAndCacheData(String lang) async {
    final res = await _repository.getNotifications(
      lang: lang,
      page: _page,
      pageSize: _pageSize,
    );

    res.when(
      success: (response) async {
        final data = response.data!;
        if (_page == 1) {
          _items.clear();
          // Cache only first page
          await CacheService.cacheNotificationsData(response);
        }
        _items.addAll(data.notifications);
        _loadingMore = false;
        emit(NotificationsState.loaded(
          notifications: List.of(_items),
          totalCount: data.totalCount,
          currentPage: data.page,
          totalPages: data.totalPages,
          hasNextPage: data.page < data.totalPages,
          loadingMore: false,
        ));
      },
      failure: (message) {
        _loadingMore = false;
        emit(NotificationsState.failed(message));
      },
    );
  }

  Future<void> loadMore({required String lang}) async {
    final current = state;
    if (current is Loaded && current.hasNextPage && !_loadingMore) {
      _page = current.currentPage + 1;
      await load(lang: lang);
    }
  }

  Future<void> refresh({required String lang}) async {
    await load(lang: lang, forceRefresh: true, reset: true);
  }

  Future<void> clearCache() async {
    await CacheService.clearNotificationsCache();
  }
}
