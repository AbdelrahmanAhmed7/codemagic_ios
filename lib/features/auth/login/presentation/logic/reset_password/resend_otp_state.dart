import 'package:freezed_annotation/freezed_annotation.dart';

part 'resend_otp_state.freezed.dart';

@freezed
class ResendOtpState<T> with _$ResendOtpState<T> {
  const factory ResendOtpState.initial() = _Initial;
  const factory ResendOtpState.loading() = Loading;
  const factory ResendOtpState.success(T data) = Success<T>;
  const factory ResendOtpState.failed({required String error}) = Failed;
}
