import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_otp_state.freezed.dart';

@freezed
class SendOtpState<T> with _$SendOtpState<T> {
  const factory SendOtpState.initial() = _Initial;
  const factory SendOtpState.loading() = Loading;
  const factory SendOtpState.success(T data) = Success<T>;
  const factory SendOtpState.failed({required String error}) = Failed;
}
