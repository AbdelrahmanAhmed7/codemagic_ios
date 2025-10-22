import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/providers/data/providers_models.dart';
import 'package:mediconsult/features/providers/presentation/cubit/providers_state.dart';
import 'package:mediconsult/features/providers/repository/providers_repository.dart';

class ProvidersCubit extends Cubit<ProvidersState> {
  final ProvidersRepository _repository;
  final Map<String, List<ProviderItem>> _searchCache = {};
  String? _lastSearchTerm;
  
  ProvidersCubit(this._repository) : super(const ProvidersState.initial());

  Future<void> loadProviders({
    required String lang,
    int page = 1,
    int pageSize = 10,
    String? search,
    int? categoryId,
  }) async {
    final current = state;
    final bool isLoadMore = current is Loaded && page > current.pagination.currentPage;
    final searchKey = search ?? 'all';

    // Check cache for first page of search
    if (page == 1 && _searchCache.containsKey(searchKey) && search == _lastSearchTerm) {
      final cachedProviders = _searchCache[searchKey]!;
      emit(ProvidersState.loaded(
        providers: cachedProviders,
        pagination: Pagination(
          currentPage: 1,
          pageSize: pageSize,
          totalCount: cachedProviders.length,
          totalPages: 1,
          hasNextPage: false,
          hasPreviousPage: false,
        ),
        searchTerm: search,
        categoryId: categoryId,
        isLoadingMore: false,
      ));
      return;
    }

    // Prevent duplicate requests
    if (isLoadMore && current.isLoadingMore) {
      return;
    }

    if (!isLoadMore) {
      emit(const ProvidersState.loading());
    } else {
      emit(current.copyWith(isLoadingMore: true));
    }

    try {
      final result = await _repository.getProviders(
        lang: lang,
        page: page,
        pageSize: pageSize,
        search: search,
        categoryId: categoryId,
      );

      result.when(
        success: (response) {
          final data = response.data!;
          if (isLoadMore) {
            // Use Set to avoid duplicates, then convert back to List
            final existingIds = current.providers.map((p) => p.id).toSet();
            final newProviders = data.providers.where((p) => !existingIds.contains(p.id)).toList();
            final merged = [...current.providers, ...newProviders];
            
            emit(ProvidersState.loaded(
              providers: merged,
              pagination: data.pagination,
              searchTerm: data.searchTerm,
              categoryId: categoryId,
              isLoadingMore: false,
            ));
          } else {
            // Cache first page results
            if (page == 1) {
              _searchCache[searchKey] = data.providers;
              _lastSearchTerm = search;
            }
            
            emit(ProvidersState.loaded(
              providers: data.providers,
              pagination: data.pagination,
              searchTerm: data.searchTerm,
              categoryId: categoryId,
              isLoadingMore: false,
            ));
          }
        },
        failure: (message) {
          emit(ProvidersState.failed(message));
        },
      );
    } catch (e) {
      emit(ProvidersState.failed('Network error: ${e.toString()}'));
    }
  }

  // Clear cache when needed
  void clearCache() {
    _searchCache.clear();
    _lastSearchTerm = null;
  }
}


