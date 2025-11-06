import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/cache/cache_service.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/terms_policy/data/terms_privacy_response.dart';
import 'package:mediconsult/features/terms_policy/presentation/cubit/terms_state.dart';
import 'package:mediconsult/features/terms_policy/repository/terms_repository.dart';

class TermsCubit extends Cubit<TermsState> {
  final TermsRepository _repo;
  TermsCubit(this._repo) : super(const TermsState.initial());

  Future<void> loadTerms(String lang, {bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await CacheService.getCachedTerms();
      if (cached != null) {
        emit(TermsState.loaded(TermsPrivacyResponse.fromJson(cached)));
        unawaited(_fetchTerms(lang));
        return;
      }
    }
    emit(const TermsState.loading());
    await _fetchTerms(lang);
  }

  Future<void> loadPrivacy(String lang, {bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await CacheService.getCachedPrivacy();
      if (cached != null) {
        emit(TermsState.loaded(TermsPrivacyResponse.fromJson(cached)));
        unawaited(_fetchPrivacy(lang));
        return;
      }
    }
    emit(const TermsState.loading());
    await _fetchPrivacy(lang);
  }

  Future<void> _fetchTerms(String lang) async {
    final res = await _repo.getTerms(lang);
    res.when(
      success: (data) async {
        await CacheService.cacheTerms(data.toJson());
        emit(TermsState.loaded(data));
      },
      failure: (msg) async {
        final cached = await CacheService.getCachedTerms();
        if (cached != null) {
          emit(TermsState.loaded(TermsPrivacyResponse.fromJson(cached)));
        } else {
          emit(TermsState.failed(msg));
        }
      },
    );
  }

  Future<void> _fetchPrivacy(String lang) async {
    final res = await _repo.getPrivacy(lang);
    res.when(
      success: (data) async {
        await CacheService.cachePrivacy(data.toJson());
        emit(TermsState.loaded(data));
      },
      failure: (msg) async {
        final cached = await CacheService.getCachedPrivacy();
        if (cached != null) {
          emit(TermsState.loaded(TermsPrivacyResponse.fromJson(cached)));
        } else {
          emit(TermsState.failed(msg));
        }
      },
    );
  }
}


