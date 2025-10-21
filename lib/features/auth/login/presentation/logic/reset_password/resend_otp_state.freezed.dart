// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resend_otp_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResendOtpState<T> {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResendOtpState<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResendOtpState<$T>()';
}


}

/// @nodoc
class $ResendOtpStateCopyWith<T,$Res>  {
$ResendOtpStateCopyWith(ResendOtpState<T> _, $Res Function(ResendOtpState<T>) __);
}


/// Adds pattern-matching-related methods to [ResendOtpState].
extension ResendOtpStatePatterns<T> on ResendOtpState<T> {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _ResendInitial<T> value)?  resendinitial,TResult Function( ResendLoading<T> value)?  resendloading,TResult Function( ResendSuccess<T> value)?  resendsuccess,TResult Function( ResendFailed<T> value)?  resendfailed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResendInitial() when resendinitial != null:
return resendinitial(_that);case ResendLoading() when resendloading != null:
return resendloading(_that);case ResendSuccess() when resendsuccess != null:
return resendsuccess(_that);case ResendFailed() when resendfailed != null:
return resendfailed(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _ResendInitial<T> value)  resendinitial,required TResult Function( ResendLoading<T> value)  resendloading,required TResult Function( ResendSuccess<T> value)  resendsuccess,required TResult Function( ResendFailed<T> value)  resendfailed,}){
final _that = this;
switch (_that) {
case _ResendInitial():
return resendinitial(_that);case ResendLoading():
return resendloading(_that);case ResendSuccess():
return resendsuccess(_that);case ResendFailed():
return resendfailed(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _ResendInitial<T> value)?  resendinitial,TResult? Function( ResendLoading<T> value)?  resendloading,TResult? Function( ResendSuccess<T> value)?  resendsuccess,TResult? Function( ResendFailed<T> value)?  resendfailed,}){
final _that = this;
switch (_that) {
case _ResendInitial() when resendinitial != null:
return resendinitial(_that);case ResendLoading() when resendloading != null:
return resendloading(_that);case ResendSuccess() when resendsuccess != null:
return resendsuccess(_that);case ResendFailed() when resendfailed != null:
return resendfailed(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  resendinitial,TResult Function()?  resendloading,TResult Function( T data)?  resendsuccess,TResult Function( String error)?  resendfailed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResendInitial() when resendinitial != null:
return resendinitial();case ResendLoading() when resendloading != null:
return resendloading();case ResendSuccess() when resendsuccess != null:
return resendsuccess(_that.data);case ResendFailed() when resendfailed != null:
return resendfailed(_that.error);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  resendinitial,required TResult Function()  resendloading,required TResult Function( T data)  resendsuccess,required TResult Function( String error)  resendfailed,}) {final _that = this;
switch (_that) {
case _ResendInitial():
return resendinitial();case ResendLoading():
return resendloading();case ResendSuccess():
return resendsuccess(_that.data);case ResendFailed():
return resendfailed(_that.error);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  resendinitial,TResult? Function()?  resendloading,TResult? Function( T data)?  resendsuccess,TResult? Function( String error)?  resendfailed,}) {final _that = this;
switch (_that) {
case _ResendInitial() when resendinitial != null:
return resendinitial();case ResendLoading() when resendloading != null:
return resendloading();case ResendSuccess() when resendsuccess != null:
return resendsuccess(_that.data);case ResendFailed() when resendfailed != null:
return resendfailed(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _ResendInitial<T> implements ResendOtpState<T> {
  const _ResendInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResendInitial<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResendOtpState<$T>.resendinitial()';
}


}




/// @nodoc


class ResendLoading<T> implements ResendOtpState<T> {
  const ResendLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResendLoading<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResendOtpState<$T>.resendloading()';
}


}




/// @nodoc


class ResendSuccess<T> implements ResendOtpState<T> {
  const ResendSuccess(this.data);
  

 final  T data;

/// Create a copy of ResendOtpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResendSuccessCopyWith<T, ResendSuccess<T>> get copyWith => _$ResendSuccessCopyWithImpl<T, ResendSuccess<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResendSuccess<T>&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'ResendOtpState<$T>.resendsuccess(data: $data)';
}


}

/// @nodoc
abstract mixin class $ResendSuccessCopyWith<T,$Res> implements $ResendOtpStateCopyWith<T, $Res> {
  factory $ResendSuccessCopyWith(ResendSuccess<T> value, $Res Function(ResendSuccess<T>) _then) = _$ResendSuccessCopyWithImpl;
@useResult
$Res call({
 T data
});




}
/// @nodoc
class _$ResendSuccessCopyWithImpl<T,$Res>
    implements $ResendSuccessCopyWith<T, $Res> {
  _$ResendSuccessCopyWithImpl(this._self, this._then);

  final ResendSuccess<T> _self;
  final $Res Function(ResendSuccess<T>) _then;

/// Create a copy of ResendOtpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(ResendSuccess<T>(
freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

/// @nodoc


class ResendFailed<T> implements ResendOtpState<T> {
  const ResendFailed({required this.error});
  

 final  String error;

/// Create a copy of ResendOtpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResendFailedCopyWith<T, ResendFailed<T>> get copyWith => _$ResendFailedCopyWithImpl<T, ResendFailed<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResendFailed<T>&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'ResendOtpState<$T>.resendfailed(error: $error)';
}


}

/// @nodoc
abstract mixin class $ResendFailedCopyWith<T,$Res> implements $ResendOtpStateCopyWith<T, $Res> {
  factory $ResendFailedCopyWith(ResendFailed<T> value, $Res Function(ResendFailed<T>) _then) = _$ResendFailedCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class _$ResendFailedCopyWithImpl<T,$Res>
    implements $ResendFailedCopyWith<T, $Res> {
  _$ResendFailedCopyWithImpl(this._self, this._then);

  final ResendFailed<T> _self;
  final $Res Function(ResendFailed<T>) _then;

/// Create a copy of ResendOtpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(ResendFailed<T>(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
