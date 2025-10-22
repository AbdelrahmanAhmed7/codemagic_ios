import 'package:flutter_bloc/flutter_bloc.dart';
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
  }) async {
    if (reset) {
      _page = 1; _items.clear();
    }
    _status = status ?? _status;
    _key = key;
    _pageSize = pageSize ?? _pageSize;

    if (_page == 1) {
      emit(const ApprovalsState.loading());
    } else {
      _loadingMore = true;
      emit(ApprovalsState.loaded(
        approvals: List.of(_items),
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

    final res = await _repository.getApprovals(
      lang: lang,
      status: _status,
      page: _page,
      pageSize: _pageSize,
      key: _key,
    );

    res.when(
      success: (response) {
        final data = response.data!;
        if (_page == 1) _items.clear();
        _items.addAll(data.approvals);
        emit(ApprovalsState.loaded(
          approvals: List.of(_items),
          pagination: data.pagination,
          status: data.filter.status,
          loadingMore: false,
        ));
      },
      failure: (message) {
        emit(ApprovalsState.failed(message));
      },
    );
  }

  Future<void> loadMore({required String lang}) async {
    final current = state;
    if (current is Loaded && current.pagination.hasNextPage && !_loadingMore) {
      _page = current.pagination.currentPage + 1;
      _loadingMore = true;
      await load(lang: lang);
    }
  }

  void changeStatus(String status, {required String lang}) {
    _status = status;
    load(lang: lang, status: status, reset: true);
  }
}


