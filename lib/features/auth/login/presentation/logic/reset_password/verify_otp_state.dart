import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_otp_state.freezed.dart';

@freezed
class VerifyOtpState<T> with _$VerifyOtpState<T> {
  const factory VerifyOtpState.initial() = _Initial;
  const factory VerifyOtpState.loading() = Loading;
  const factory VerifyOtpState.success(T data) = Success<T>;
  const factory VerifyOtpState.failed({required String error}) = Failed;
}