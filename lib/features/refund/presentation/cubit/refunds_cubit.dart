import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/features/approval_request/data/approvals_models.dart';
import 'package:mediconsult/features/refund/presentation/cubit/refunds_state.dart';

class RefundsCubit extends Cubit<RefundsState> {
  RefundsCubit() : super(const RefundsState.initial());

  final List<RefundItem> _all = [
    RefundItem(
      id: 1,
      providerLogo: null,
      providerName: 'مستشفيات ميديكال',
      requestNumber: '27749',
      date: '22 Nov 2025',
      time: '09:44 AM',
      status: 'Approved',
      statusChar: 'A',
    ),
    RefundItem(
      id: 2,
      providerLogo: null,
      providerName: 'مستشفيات ميديكال',
      requestNumber: '27750',
      date: '22 Nov 2025',
      time: '09:44 AM',
      status: 'Rejected',
      statusChar: 'R',
    ),
    RefundItem(
      id: 3,
      providerLogo: null,
      providerName: 'مستشفيات ميديكال',
      requestNumber: '27751',
      date: '22 Nov 2025',
      time: '09:44 AM',
      status: 'Pending',
      statusChar: 'P',
    ),
  ];

  String _status = 'All';
  int _page = 1;
  final int _pageSize = 10;

  Future<void> load({String? status, bool reset = false}) async {
    emit(const RefundsState.loading());

    if (status != null) _status = status;
    if (reset) _page = 1;

    await Future.delayed(const Duration(milliseconds: 300));

    final filtered = _status == 'All'
        ? _all
        : _all.where((e) => e.status == _status).toList();

    final pagination = Pagination(
      currentPage: _page,
      pageSize: _pageSize,
      totalCount: filtered.length,
      totalPages: 1,
      hasNextPage: false,
      hasPreviousPage: false,
    );

    emit(
      RefundsState.loaded(
        refunds: filtered,
        pagination: pagination,
        status: _status,
      ),
    );
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is Loaded && current.pagination.hasNextPage) {
      emit(current.copyWith(loadingMore: true));
      await Future.delayed(const Duration(milliseconds: 250));
      emit(current.copyWith(loadingMore: false));
    }
  }

  void changeStatus(String status) {
    load(status: status, reset: true);
  }

  Future<void> refreshRefunds() async {
    await load(reset: true);
  }
}