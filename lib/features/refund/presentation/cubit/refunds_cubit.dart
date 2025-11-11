import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/cache/cache_service.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/refund/data/refund_list_models.dart';
import 'package:mediconsult/features/refund/presentation/cubit/refunds_state.dart';
import 'package:mediconsult/features/refund/repository/refund_repository.dart';

class RefundsCubit extends Cubit<RefundsState> {
  final RefundRepository _repository;
  
  RefundsCubit(this._repository) : super(const RefundsState.initial());

  // Cache for refunds by status
  final Map<String, List<RefundItem>> _cache = {};
  final Map<String, PaginationInfo> _paginationCache = {};

  String _status = 'All';
  int _page = 1;
  final int _pageSize = 10;

  Future<void> load({
    required String lang,
    String? status,
    bool reset = false,
    bool forceRefresh = false,
    bool isLoadingMore = false,
  }) async {
    if (status != null) _status = status;
    if (reset) _page = 1;

    // Try persistent cache for first page only
    if (_page == 1 && !forceRefresh) {
      final cachedData = await CacheService.getCachedRefundsData(_status);
      if (cachedData != null && cachedData.data != null) {
        final data = cachedData.data!;
        _cache[_status] = data.refunds;
        _paginationCache[_status] = data.pagination;
        emit(
          RefundsState.loaded(
            refunds: data.refunds,
            pagination: data.pagination,
            status: _status,
            loadingMore: false,
          ),
        );
        
        // Background refresh
        unawaited(_fetchAndCacheData(lang, isLoadingMore));
        return;
      }
    }

    // Don't emit loading if we're loading more
    if (!isLoadingMore) {
      emit(const RefundsState.loading());
    }

    await _fetchAndCacheData(lang, isLoadingMore);
  }

  Future<void> _fetchAndCacheData(String lang, bool isLoadingMore) async {
    final result = await _repository.getRefunds(
      lang: lang,
      page: _page,
      pageSize: _pageSize,
      status: _status,
    );

    result.when(
      success: (response) async {
        if (response.data != null) {
          final refunds = response.data!.refunds;
          final pagination = response.data!.pagination;

          // Update cache
          if (_page == 1) {
            _cache[_status] = refunds;
            _paginationCache[_status] = pagination;
            // Cache only first page in persistent storage
            await CacheService.cacheRefundsData(response, _status);
          } else {
            _cache[_status] = [...(_cache[_status] ?? []), ...refunds];
          }

          emit(
            RefundsState.loaded(
              refunds: _cache[_status]!,
              pagination: pagination,
              status: _status,
              loadingMore: false,
            ),
          );
        } else {
          emit(const RefundsState.failed('No data available'));
        }
      },
      failure: (message) {
        // If we were loading more, keep the current items and just show error
        final current = state;
        if (isLoadingMore && current is Loaded) {
          emit(current.copyWith(loadingMore: false));
          // Optionally show a snackbar or toast here
        } else {
          emit(RefundsState.failed(message));
        }
      },
    );
  }

  Future<void> loadMore(String lang) async {
    final current = state;
    if (current is Loaded && current.pagination.hasNextPage) {
      final previousPage = _page;
      emit(current.copyWith(loadingMore: true));
      _page++;
      
      await load(lang: lang, isLoadingMore: true);
      
      // If load failed and we're still in loaded state with loadingMore false,
      // it means the error was handled and we should revert the page
      final newState = state;
      if (newState is Loaded && !newState.loadingMore && newState.refunds.length == current.refunds.length) {
        _page = previousPage;
      }
    }
  }

  void changeStatus(String lang, String status) {
    load(lang: lang, status: status, reset: true);
  }

  Future<void> refreshRefunds(String lang) async {
    await load(lang: lang, reset: true, forceRefresh: true);
  }

  Future<void> clearCache() async {
    _cache.clear();
    _paginationCache.clear();
    await CacheService.clearAllRefundsCache();
  }
}