import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mediconsult/features/providers/data/providers_models.dart';

part 'providers_state.freezed.dart';

@freezed
class ProvidersState with _$ProvidersState {
  const factory ProvidersState.initial() = _Initial;

  const factory ProvidersState.loading() = Loading;

  const factory ProvidersState.loaded({
    required List<ProviderItem> providers,
    required Pagination pagination,
    String? searchTerm,
    int? categoryId,
    @Default(false) bool isLoadingMore,
  }) = Loaded;

  const factory ProvidersState.failed(String message) = Failed;
}


