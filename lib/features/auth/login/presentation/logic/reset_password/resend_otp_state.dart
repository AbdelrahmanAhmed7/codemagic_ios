import 'package:freezed_annotation/freezed_annotation.dart';

part 'resend_otp_state.freezed.dart';

@freezed
class ResendOtpState<T> with _$ResendOtpState<T> {
  const factory ResendOtpState.resendinitial() = _ResendInitial;
  const factory ResendOtpState.resendloading() = ResendLoading;
  const factory ResendOtpState.resendsuccess(T data) = ResendSuccess<T>;
  const factory ResendOtpState.resendfailed({required String error}) = ResendFailed;
}
