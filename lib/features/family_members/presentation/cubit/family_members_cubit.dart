import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/cache/cache_service.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/family_members/presentation/cubit/family_members_state.dart';
import 'package:mediconsult/features/family_members/repository/family_member_repo.dart';

class FamilyMembersCubit extends Cubit<FamilyMembersState> {
  final FamilyMemberRepository _familyMemberRepository;

  FamilyMembersCubit(this._familyMemberRepository)
    : super(FamilyMembersState.initial());

  Future<void> getFamilyMembers(String lang, {bool forceRefresh = false}) async {
    try {
      // Check cache first
      if (!forceRefresh) {
        final cachedData = await CacheService.getCachedFamilyData();
        if (cachedData != null) {
          emit(FamilyMembersState.loaded(cachedData));
          
          // Background refresh if needed
          unawaited(_fetchAndCacheData(lang));
          return;
        }
      }

      // No cache, show loading
      emit(FamilyMembersState.loading());
      await _fetchAndCacheData(lang);
    } catch (e) {
      emit(FamilyMembersState.failed(e.toString()));
    }
  }

  Future<void> _fetchAndCacheData(String lang) async {
    final response = await _familyMemberRepository.getFamilyMembers(lang);
    response.when(
      success: (data) async {
        await CacheService.cacheFamilyData(data);
        emit(FamilyMembersState.loaded(data));
      },
      failure: (error) {
        emit(FamilyMembersState.failed(error));
      },
    );
  }

  Future<void> refreshFamilyMembers(String lang) async {
    await getFamilyMembers(lang, forceRefresh: true);
  }

  Future<void> clearCache() async {
    await CacheService.clearFamilyCache();
  }
}
