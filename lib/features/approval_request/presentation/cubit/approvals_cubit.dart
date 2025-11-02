import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/cache/cache_service.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/approval_request/data/approvals_models.dart';
import 'package:mediconsult/features/approval_request/presentation/cubit/approvals_state.dart';
import 'package:mediconsult/features/approval_request/repository/approvals_repository.dart';

class ApprovalsCubit extends Cubit<ApprovalsState> {
  final ApprovalsRepository _repository;
  ApprovalsCubit(this._repository) : super(const ApprovalsState.initial());

  String _status = 'All';
  String? _key;
  int _page = 1;
  int _pageSize = 10;
  bool _loadingMore = false;
  final List<ApprovalItem> _items = [];

  Future<void> load({
    required String lang,
    String? status,
    String? key,
    int? pageSize,
    bool reset = false,
    bool forceRefresh = false,
  }) async {
    if (reset) {
      _page = 1; _items.clear();
    }
    _status = status ?? _status;
    _key = key;
    _pageSize = pageSize ?? _pageSize;

    // Try cache for first page only
    if (_page == 1 && !forceRefresh && _key == null) {
      final cachedData = await CacheService.getCachedApprovalsData(_status);
      if (cachedData != null && cachedData.data != null) {
        final data = cachedData.data!;
        _items.clear();
        _items.addAll(data.approvals);
        emit(ApprovalsState.loaded(
          approvals: _items,
          pagination: data.pagination,
          status: data.filter.status,
          loadingMore: false,
        ));
        
        // Background refresh
        unawaited(_fetchAndCacheData(lang));
        return;
      }
    }

    if (_page == 1) {
      emit(const ApprovalsState.loading());
    } else {
      _loadingMore = true;
      emit(ApprovalsState.loaded(
        approvals: _items,
        pagination: Pagination(
          currentPage: _page-1,
          pageSize: _pageSize,
          totalCount: _items.length,
          totalPages: 1,
          hasNextPage: true,
          hasPreviousPage: _page > 1,
        ),
        status: _status,
        loadingMore: true,
      ));
    }

    await _fetchAndCacheData(lang);
  }

  Future<void> _fetchAndCacheData(String lang) async {
    final res = await _repository.getApprovals(
      lang: lang,
      status: _status,
      page: _page,
      pageSize: _pageSize,
      key: _key,
    );

    res.when(
      success: (response) async {
        final data = response.data!;
        if (_page == 1) {
          _items.clear();
          // Cache only first page
          if (_key == null) {
            await CacheService.cacheApprovalsData(response, _status);
          }
        }
        _items.addAll(data.approvals);
        _loadingMore = false;
        emit(ApprovalsState.loaded(
          approvals: _items,
          pagination: data.pagination,
          status: data.filter.status,
          loadingMore: false,
        ));
      },
      failure: (message) {
        _loadingMore = false;
        emit(ApprovalsState.failed(message));
      },
    );
  }

  Future<void> loadMore({required String lang}) async {
    final current = state;
    if (current is Loaded && 
        current.pagination.hasNextPage && 
        !_loadingMore) {
      _page = current.pagination.currentPage + 1;
      await load(lang: lang);
    }
  }

  void changeStatus(String status, {required String lang}) {
    _status = status;
    load(lang: lang, status: status, reset: true);
  }

  Future<void> refreshApprovals({required String lang}) async {
    await load(lang: lang, forceRefresh: true, reset: true);
  }

  Future<void> clearCache() async {
    await CacheService.clearAllApprovalsCache();
  }
}


