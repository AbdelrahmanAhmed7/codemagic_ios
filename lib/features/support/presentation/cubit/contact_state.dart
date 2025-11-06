import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mediconsult/features/support/data/contacts_response_model.dart';

part 'contact_state.freezed.dart';

@freezed
class ContactState with _$ContactState {
  const factory ContactState.initial() = _Initial;
  const factory ContactState.loading() = Loading;
  const factory ContactState.loaded(ContactsResponse data) = Loaded;
  const factory ContactState.failed(String message) = Failed;
}