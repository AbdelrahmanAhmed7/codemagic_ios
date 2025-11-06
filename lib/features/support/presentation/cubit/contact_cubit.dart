import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/cache/cache_service.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/support/data/contacts_response_model.dart';
import 'package:mediconsult/features/support/presentation/cubit/contact_state.dart';
import 'package:mediconsult/features/support/repository/support_repository.dart';

class ContactCubit extends Cubit<ContactState> {
  final SupportRepository _repository;
  ContactCubit(this._repository) : super(const ContactState.initial());

  Future<void> load({required String lang, bool forceRefresh = false}) async {
    try {
      if (!forceRefresh) {
        final cached = await CacheService.getCachedContactsData();
        if (cached != null) {
          final data = ContactsResponse.fromJson(cached);
          emit(ContactState.loaded(data));
          unawaited(_fetchAndCache(lang));
          return;
        }
      }
      emit(const ContactState.loading());
      await _fetchAndCache(lang);
    } catch (e) {
      emit(ContactState.failed(e.toString()));
    }
  }

  Future<void> _fetchAndCache(String lang) async {
    final result = await _repository.getContacts(lang);
    result.when(
      success: (data) async {
        await CacheService.cacheContactsData(data.toJson());
        emit(ContactState.loaded(data));
      },
      failure: (message) async {
        final cached = await CacheService.getCachedContactsData();
        if (cached != null) {
          emit(ContactState.loaded(ContactsResponse.fromJson(cached)));
        } else {
          emit(ContactState.failed(message));
        }
      },
    );
  }
}


