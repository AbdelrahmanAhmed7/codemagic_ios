// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'refunds_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RefundsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefundsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RefundsState()';
}


}

/// @nodoc
class $RefundsStateCopyWith<$Res>  {
$RefundsStateCopyWith(RefundsState _, $Res Function(RefundsState) __);
}


/// Adds pattern-matching-related methods to [RefundsState].
extension RefundsStatePatterns on RefundsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( Loading value)?  loading,TResult Function( Loaded value)?  loaded,TResult Function( Failed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case Loading() when loading != null:
return loading(_that);case Loaded() when loaded != null:
return loaded(_that);case Failed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( Loading value)  loading,required TResult Function( Loaded value)  loaded,required TResult Function( Failed value)  failed,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case Loading():
return loading(_that);case Loaded():
return loaded(_that);case Failed():
return failed(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( Loading value)?  loading,TResult? Function( Loaded value)?  loaded,TResult? Function( Failed value)?  failed,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case Loading() when loading != null:
return loading(_that);case Loaded() when loaded != null:
return loaded(_that);case Failed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<RefundItem> refunds,  PaginationInfo pagination,  String status,  bool loadingMore)?  loaded,TResult Function( String message)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case Loading() when loading != null:
return loading();case Loaded() when loaded != null:
return loaded(_that.refunds,_that.pagination,_that.status,_that.loadingMore);case Failed() when failed != null:
return failed(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<RefundItem> refunds,  PaginationInfo pagination,  String status,  bool loadingMore)  loaded,required TResult Function( String message)  failed,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case Loading():
return loading();case Loaded():
return loaded(_that.refunds,_that.pagination,_that.status,_that.loadingMore);case Failed():
return failed(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<RefundItem> refunds,  PaginationInfo pagination,  String status,  bool loadingMore)?  loaded,TResult? Function( String message)?  failed,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case Loading() when loading != null:
return loading();case Loaded() when loaded != null:
return loaded(_that.refunds,_that.pagination,_that.status,_that.loadingMore);case Failed() when failed != null:
return failed(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements RefundsState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RefundsState.initial()';
}


}




/// @nodoc


class Loading implements RefundsState {
  const Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RefundsState.loading()';
}


}




/// @nodoc


class Loaded implements RefundsState {
  const Loaded({required final  List<RefundItem> refunds, required this.pagination, required this.status, this.loadingMore = false}): _refunds = refunds;
  

 final  List<RefundItem> _refunds;
 List<RefundItem> get refunds {
  if (_refunds is EqualUnmodifiableListView) return _refunds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_refunds);
}

 final  PaginationInfo pagination;
 final  String status;
@JsonKey() final  bool loadingMore;

/// Create a copy of RefundsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadedCopyWith<Loaded> get copyWith => _$LoadedCopyWithImpl<Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Loaded&&const DeepCollectionEquality().equals(other._refunds, _refunds)&&(identical(other.pagination, pagination) || other.pagination == pagination)&&(identical(other.status, status) || other.status == status)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_refunds),pagination,status,loadingMore);

@override
String toString() {
  return 'RefundsState.loaded(refunds: $refunds, pagination: $pagination, status: $status, loadingMore: $loadingMore)';
}


}

/// @nodoc
abstract mixin class $LoadedCopyWith<$Res> implements $RefundsStateCopyWith<$Res> {
  factory $LoadedCopyWith(Loaded value, $Res Function(Loaded) _then) = _$LoadedCopyWithImpl;
@useResult
$Res call({
 List<RefundItem> refunds, PaginationInfo pagination, String status, bool loadingMore
});




}
/// @nodoc
class _$LoadedCopyWithImpl<$Res>
    implements $LoadedCopyWith<$Res> {
  _$LoadedCopyWithImpl(this._self, this._then);

  final Loaded _self;
  final $Res Function(Loaded) _then;

/// Create a copy of RefundsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? refunds = null,Object? pagination = null,Object? status = null,Object? loadingMore = null,}) {
  return _then(Loaded(
refunds: null == refunds ? _self._refunds : refunds // ignore: cast_nullable_to_non_nullable
as List<RefundItem>,pagination: null == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as PaginationInfo,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class Failed implements RefundsState {
  const Failed(this.message);
  

 final  String message;

/// Create a copy of RefundsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FailedCopyWith<Failed> get copyWith => _$FailedCopyWithImpl<Failed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Failed&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'RefundsState.failed(message: $message)';
}


}

/// @nodoc
abstract mixin class $FailedCopyWith<$Res> implements $RefundsStateCopyWith<$Res> {
  factory $FailedCopyWith(Failed value, $Res Function(Failed) _then) = _$FailedCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$FailedCopyWithImpl<$Res>
    implements $FailedCopyWith<$Res> {
  _$FailedCopyWithImpl(this._self, this._then);

  final Failed _self;
  final $Res Function(Failed) _then;

/// Create a copy of RefundsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(Failed(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
