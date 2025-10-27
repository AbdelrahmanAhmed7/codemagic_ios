// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'network_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NetworkState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NetworkState()';
}


}

/// @nodoc
class $NetworkStateCopyWith<$Res>  {
$NetworkStateCopyWith(NetworkState _, $Res Function(NetworkState) __);
}


/// Adds pattern-matching-related methods to [NetworkState].
extension NetworkStatePatterns on NetworkState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( CategoriesLoading value)?  categoriesLoading,TResult Function( CategoriesSuccess value)?  categoriesSuccess,TResult Function( CategoriesError value)?  categoriesError,TResult Function( ProvidersLoading value)?  providersLoading,TResult Function( ProvidersSuccess value)?  providersSuccess,TResult Function( ProvidersError value)?  providersError,TResult Function( ProvidersEmpty value)?  providersEmpty,TResult Function( ProvidersLoadingMore value)?  providersLoadingMore,TResult Function( GovernmentsLoading value)?  governmentsLoading,TResult Function( GovernmentsSuccess value)?  governmentsSuccess,TResult Function( GovernmentsError value)?  governmentsError,TResult Function( CitiesLoading value)?  citiesLoading,TResult Function( CitiesSuccess value)?  citiesSuccess,TResult Function( CitiesError value)?  citiesError,TResult Function( LocationLoading value)?  locationLoading,TResult Function( LocationSuccess value)?  locationSuccess,TResult Function( LocationError value)?  locationError,TResult Function( LocationPermissionDenied value)?  locationPermissionDenied,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case CategoriesLoading() when categoriesLoading != null:
return categoriesLoading(_that);case CategoriesSuccess() when categoriesSuccess != null:
return categoriesSuccess(_that);case CategoriesError() when categoriesError != null:
return categoriesError(_that);case ProvidersLoading() when providersLoading != null:
return providersLoading(_that);case ProvidersSuccess() when providersSuccess != null:
return providersSuccess(_that);case ProvidersError() when providersError != null:
return providersError(_that);case ProvidersEmpty() when providersEmpty != null:
return providersEmpty(_that);case ProvidersLoadingMore() when providersLoadingMore != null:
return providersLoadingMore(_that);case GovernmentsLoading() when governmentsLoading != null:
return governmentsLoading(_that);case GovernmentsSuccess() when governmentsSuccess != null:
return governmentsSuccess(_that);case GovernmentsError() when governmentsError != null:
return governmentsError(_that);case CitiesLoading() when citiesLoading != null:
return citiesLoading(_that);case CitiesSuccess() when citiesSuccess != null:
return citiesSuccess(_that);case CitiesError() when citiesError != null:
return citiesError(_that);case LocationLoading() when locationLoading != null:
return locationLoading(_that);case LocationSuccess() when locationSuccess != null:
return locationSuccess(_that);case LocationError() when locationError != null:
return locationError(_that);case LocationPermissionDenied() when locationPermissionDenied != null:
return locationPermissionDenied(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( CategoriesLoading value)  categoriesLoading,required TResult Function( CategoriesSuccess value)  categoriesSuccess,required TResult Function( CategoriesError value)  categoriesError,required TResult Function( ProvidersLoading value)  providersLoading,required TResult Function( ProvidersSuccess value)  providersSuccess,required TResult Function( ProvidersError value)  providersError,required TResult Function( ProvidersEmpty value)  providersEmpty,required TResult Function( ProvidersLoadingMore value)  providersLoadingMore,required TResult Function( GovernmentsLoading value)  governmentsLoading,required TResult Function( GovernmentsSuccess value)  governmentsSuccess,required TResult Function( GovernmentsError value)  governmentsError,required TResult Function( CitiesLoading value)  citiesLoading,required TResult Function( CitiesSuccess value)  citiesSuccess,required TResult Function( CitiesError value)  citiesError,required TResult Function( LocationLoading value)  locationLoading,required TResult Function( LocationSuccess value)  locationSuccess,required TResult Function( LocationError value)  locationError,required TResult Function( LocationPermissionDenied value)  locationPermissionDenied,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case CategoriesLoading():
return categoriesLoading(_that);case CategoriesSuccess():
return categoriesSuccess(_that);case CategoriesError():
return categoriesError(_that);case ProvidersLoading():
return providersLoading(_that);case ProvidersSuccess():
return providersSuccess(_that);case ProvidersError():
return providersError(_that);case ProvidersEmpty():
return providersEmpty(_that);case ProvidersLoadingMore():
return providersLoadingMore(_that);case GovernmentsLoading():
return governmentsLoading(_that);case GovernmentsSuccess():
return governmentsSuccess(_that);case GovernmentsError():
return governmentsError(_that);case CitiesLoading():
return citiesLoading(_that);case CitiesSuccess():
return citiesSuccess(_that);case CitiesError():
return citiesError(_that);case LocationLoading():
return locationLoading(_that);case LocationSuccess():
return locationSuccess(_that);case LocationError():
return locationError(_that);case LocationPermissionDenied():
return locationPermissionDenied(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( CategoriesLoading value)?  categoriesLoading,TResult? Function( CategoriesSuccess value)?  categoriesSuccess,TResult? Function( CategoriesError value)?  categoriesError,TResult? Function( ProvidersLoading value)?  providersLoading,TResult? Function( ProvidersSuccess value)?  providersSuccess,TResult? Function( ProvidersError value)?  providersError,TResult? Function( ProvidersEmpty value)?  providersEmpty,TResult? Function( ProvidersLoadingMore value)?  providersLoadingMore,TResult? Function( GovernmentsLoading value)?  governmentsLoading,TResult? Function( GovernmentsSuccess value)?  governmentsSuccess,TResult? Function( GovernmentsError value)?  governmentsError,TResult? Function( CitiesLoading value)?  citiesLoading,TResult? Function( CitiesSuccess value)?  citiesSuccess,TResult? Function( CitiesError value)?  citiesError,TResult? Function( LocationLoading value)?  locationLoading,TResult? Function( LocationSuccess value)?  locationSuccess,TResult? Function( LocationError value)?  locationError,TResult? Function( LocationPermissionDenied value)?  locationPermissionDenied,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case CategoriesLoading() when categoriesLoading != null:
return categoriesLoading(_that);case CategoriesSuccess() when categoriesSuccess != null:
return categoriesSuccess(_that);case CategoriesError() when categoriesError != null:
return categoriesError(_that);case ProvidersLoading() when providersLoading != null:
return providersLoading(_that);case ProvidersSuccess() when providersSuccess != null:
return providersSuccess(_that);case ProvidersError() when providersError != null:
return providersError(_that);case ProvidersEmpty() when providersEmpty != null:
return providersEmpty(_that);case ProvidersLoadingMore() when providersLoadingMore != null:
return providersLoadingMore(_that);case GovernmentsLoading() when governmentsLoading != null:
return governmentsLoading(_that);case GovernmentsSuccess() when governmentsSuccess != null:
return governmentsSuccess(_that);case GovernmentsError() when governmentsError != null:
return governmentsError(_that);case CitiesLoading() when citiesLoading != null:
return citiesLoading(_that);case CitiesSuccess() when citiesSuccess != null:
return citiesSuccess(_that);case CitiesError() when citiesError != null:
return citiesError(_that);case LocationLoading() when locationLoading != null:
return locationLoading(_that);case LocationSuccess() when locationSuccess != null:
return locationSuccess(_that);case LocationError() when locationError != null:
return locationError(_that);case LocationPermissionDenied() when locationPermissionDenied != null:
return locationPermissionDenied(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  categoriesLoading,TResult Function( List<NetworkCategory> categories)?  categoriesSuccess,TResult Function( String error)?  categoriesError,TResult Function()?  providersLoading,TResult Function( NetworkProviderData data)?  providersSuccess,TResult Function( String error)?  providersError,TResult Function()?  providersEmpty,TResult Function( NetworkProviderData data)?  providersLoadingMore,TResult Function()?  governmentsLoading,TResult Function( List<Government> governments)?  governmentsSuccess,TResult Function( String error)?  governmentsError,TResult Function()?  citiesLoading,TResult Function( List<City> cities)?  citiesSuccess,TResult Function( String error)?  citiesError,TResult Function()?  locationLoading,TResult Function( double latitude,  double longitude)?  locationSuccess,TResult Function( String error)?  locationError,TResult Function()?  locationPermissionDenied,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case CategoriesLoading() when categoriesLoading != null:
return categoriesLoading();case CategoriesSuccess() when categoriesSuccess != null:
return categoriesSuccess(_that.categories);case CategoriesError() when categoriesError != null:
return categoriesError(_that.error);case ProvidersLoading() when providersLoading != null:
return providersLoading();case ProvidersSuccess() when providersSuccess != null:
return providersSuccess(_that.data);case ProvidersError() when providersError != null:
return providersError(_that.error);case ProvidersEmpty() when providersEmpty != null:
return providersEmpty();case ProvidersLoadingMore() when providersLoadingMore != null:
return providersLoadingMore(_that.data);case GovernmentsLoading() when governmentsLoading != null:
return governmentsLoading();case GovernmentsSuccess() when governmentsSuccess != null:
return governmentsSuccess(_that.governments);case GovernmentsError() when governmentsError != null:
return governmentsError(_that.error);case CitiesLoading() when citiesLoading != null:
return citiesLoading();case CitiesSuccess() when citiesSuccess != null:
return citiesSuccess(_that.cities);case CitiesError() when citiesError != null:
return citiesError(_that.error);case LocationLoading() when locationLoading != null:
return locationLoading();case LocationSuccess() when locationSuccess != null:
return locationSuccess(_that.latitude,_that.longitude);case LocationError() when locationError != null:
return locationError(_that.error);case LocationPermissionDenied() when locationPermissionDenied != null:
return locationPermissionDenied();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  categoriesLoading,required TResult Function( List<NetworkCategory> categories)  categoriesSuccess,required TResult Function( String error)  categoriesError,required TResult Function()  providersLoading,required TResult Function( NetworkProviderData data)  providersSuccess,required TResult Function( String error)  providersError,required TResult Function()  providersEmpty,required TResult Function( NetworkProviderData data)  providersLoadingMore,required TResult Function()  governmentsLoading,required TResult Function( List<Government> governments)  governmentsSuccess,required TResult Function( String error)  governmentsError,required TResult Function()  citiesLoading,required TResult Function( List<City> cities)  citiesSuccess,required TResult Function( String error)  citiesError,required TResult Function()  locationLoading,required TResult Function( double latitude,  double longitude)  locationSuccess,required TResult Function( String error)  locationError,required TResult Function()  locationPermissionDenied,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case CategoriesLoading():
return categoriesLoading();case CategoriesSuccess():
return categoriesSuccess(_that.categories);case CategoriesError():
return categoriesError(_that.error);case ProvidersLoading():
return providersLoading();case ProvidersSuccess():
return providersSuccess(_that.data);case ProvidersError():
return providersError(_that.error);case ProvidersEmpty():
return providersEmpty();case ProvidersLoadingMore():
return providersLoadingMore(_that.data);case GovernmentsLoading():
return governmentsLoading();case GovernmentsSuccess():
return governmentsSuccess(_that.governments);case GovernmentsError():
return governmentsError(_that.error);case CitiesLoading():
return citiesLoading();case CitiesSuccess():
return citiesSuccess(_that.cities);case CitiesError():
return citiesError(_that.error);case LocationLoading():
return locationLoading();case LocationSuccess():
return locationSuccess(_that.latitude,_that.longitude);case LocationError():
return locationError(_that.error);case LocationPermissionDenied():
return locationPermissionDenied();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  categoriesLoading,TResult? Function( List<NetworkCategory> categories)?  categoriesSuccess,TResult? Function( String error)?  categoriesError,TResult? Function()?  providersLoading,TResult? Function( NetworkProviderData data)?  providersSuccess,TResult? Function( String error)?  providersError,TResult? Function()?  providersEmpty,TResult? Function( NetworkProviderData data)?  providersLoadingMore,TResult? Function()?  governmentsLoading,TResult? Function( List<Government> governments)?  governmentsSuccess,TResult? Function( String error)?  governmentsError,TResult? Function()?  citiesLoading,TResult? Function( List<City> cities)?  citiesSuccess,TResult? Function( String error)?  citiesError,TResult? Function()?  locationLoading,TResult? Function( double latitude,  double longitude)?  locationSuccess,TResult? Function( String error)?  locationError,TResult? Function()?  locationPermissionDenied,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case CategoriesLoading() when categoriesLoading != null:
return categoriesLoading();case CategoriesSuccess() when categoriesSuccess != null:
return categoriesSuccess(_that.categories);case CategoriesError() when categoriesError != null:
return categoriesError(_that.error);case ProvidersLoading() when providersLoading != null:
return providersLoading();case ProvidersSuccess() when providersSuccess != null:
return providersSuccess(_that.data);case ProvidersError() when providersError != null:
return providersError(_that.error);case ProvidersEmpty() when providersEmpty != null:
return providersEmpty();case ProvidersLoadingMore() when providersLoadingMore != null:
return providersLoadingMore(_that.data);case GovernmentsLoading() when governmentsLoading != null:
return governmentsLoading();case GovernmentsSuccess() when governmentsSuccess != null:
return governmentsSuccess(_that.governments);case GovernmentsError() when governmentsError != null:
return governmentsError(_that.error);case CitiesLoading() when citiesLoading != null:
return citiesLoading();case CitiesSuccess() when citiesSuccess != null:
return citiesSuccess(_that.cities);case CitiesError() when citiesError != null:
return citiesError(_that.error);case LocationLoading() when locationLoading != null:
return locationLoading();case LocationSuccess() when locationSuccess != null:
return locationSuccess(_that.latitude,_that.longitude);case LocationError() when locationError != null:
return locationError(_that.error);case LocationPermissionDenied() when locationPermissionDenied != null:
return locationPermissionDenied();case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements NetworkState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NetworkState.initial()';
}


}




/// @nodoc


class CategoriesLoading implements NetworkState {
  const CategoriesLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoriesLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NetworkState.categoriesLoading()';
}


}




/// @nodoc


class CategoriesSuccess implements NetworkState {
  const CategoriesSuccess(final  List<NetworkCategory> categories): _categories = categories;
  

 final  List<NetworkCategory> _categories;
 List<NetworkCategory> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}


/// Create a copy of NetworkState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoriesSuccessCopyWith<CategoriesSuccess> get copyWith => _$CategoriesSuccessCopyWithImpl<CategoriesSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoriesSuccess&&const DeepCollectionEquality().equals(other._categories, _categories));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_categories));

@override
String toString() {
  return 'NetworkState.categoriesSuccess(categories: $categories)';
}


}

/// @nodoc
abstract mixin class $CategoriesSuccessCopyWith<$Res> implements $NetworkStateCopyWith<$Res> {
  factory $CategoriesSuccessCopyWith(CategoriesSuccess value, $Res Function(CategoriesSuccess) _then) = _$CategoriesSuccessCopyWithImpl;
@useResult
$Res call({
 List<NetworkCategory> categories
});




}
/// @nodoc
class _$CategoriesSuccessCopyWithImpl<$Res>
    implements $CategoriesSuccessCopyWith<$Res> {
  _$CategoriesSuccessCopyWithImpl(this._self, this._then);

  final CategoriesSuccess _self;
  final $Res Function(CategoriesSuccess) _then;

/// Create a copy of NetworkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categories = null,}) {
  return _then(CategoriesSuccess(
null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<NetworkCategory>,
  ));
}


}

/// @nodoc


class CategoriesError implements NetworkState {
  const CategoriesError(this.error);
  

 final  String error;

/// Create a copy of NetworkState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoriesErrorCopyWith<CategoriesError> get copyWith => _$CategoriesErrorCopyWithImpl<CategoriesError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoriesError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'NetworkState.categoriesError(error: $error)';
}


}

/// @nodoc
abstract mixin class $CategoriesErrorCopyWith<$Res> implements $NetworkStateCopyWith<$Res> {
  factory $CategoriesErrorCopyWith(CategoriesError value, $Res Function(CategoriesError) _then) = _$CategoriesErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class _$CategoriesErrorCopyWithImpl<$Res>
    implements $CategoriesErrorCopyWith<$Res> {
  _$CategoriesErrorCopyWithImpl(this._self, this._then);

  final CategoriesError _self;
  final $Res Function(CategoriesError) _then;

/// Create a copy of NetworkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(CategoriesError(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ProvidersLoading implements NetworkState {
  const ProvidersLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProvidersLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NetworkState.providersLoading()';
}


}




/// @nodoc


class ProvidersSuccess implements NetworkState {
  const ProvidersSuccess(this.data);
  

 final  NetworkProviderData data;

/// Create a copy of NetworkState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProvidersSuccessCopyWith<ProvidersSuccess> get copyWith => _$ProvidersSuccessCopyWithImpl<ProvidersSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProvidersSuccess&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'NetworkState.providersSuccess(data: $data)';
}


}

/// @nodoc
abstract mixin class $ProvidersSuccessCopyWith<$Res> implements $NetworkStateCopyWith<$Res> {
  factory $ProvidersSuccessCopyWith(ProvidersSuccess value, $Res Function(ProvidersSuccess) _then) = _$ProvidersSuccessCopyWithImpl;
@useResult
$Res call({
 NetworkProviderData data
});




}
/// @nodoc
class _$ProvidersSuccessCopyWithImpl<$Res>
    implements $ProvidersSuccessCopyWith<$Res> {
  _$ProvidersSuccessCopyWithImpl(this._self, this._then);

  final ProvidersSuccess _self;
  final $Res Function(ProvidersSuccess) _then;

/// Create a copy of NetworkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(ProvidersSuccess(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as NetworkProviderData,
  ));
}


}

/// @nodoc


class ProvidersError implements NetworkState {
  const ProvidersError(this.error);
  

 final  String error;

/// Create a copy of NetworkState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProvidersErrorCopyWith<ProvidersError> get copyWith => _$ProvidersErrorCopyWithImpl<ProvidersError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProvidersError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'NetworkState.providersError(error: $error)';
}


}

/// @nodoc
abstract mixin class $ProvidersErrorCopyWith<$Res> implements $NetworkStateCopyWith<$Res> {
  factory $ProvidersErrorCopyWith(ProvidersError value, $Res Function(ProvidersError) _then) = _$ProvidersErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class _$ProvidersErrorCopyWithImpl<$Res>
    implements $ProvidersErrorCopyWith<$Res> {
  _$ProvidersErrorCopyWithImpl(this._self, this._then);

  final ProvidersError _self;
  final $Res Function(ProvidersError) _then;

/// Create a copy of NetworkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(ProvidersError(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ProvidersEmpty implements NetworkState {
  const ProvidersEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProvidersEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NetworkState.providersEmpty()';
}


}




/// @nodoc


class ProvidersLoadingMore implements NetworkState {
  const ProvidersLoadingMore(this.data);
  

 final  NetworkProviderData data;

/// Create a copy of NetworkState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProvidersLoadingMoreCopyWith<ProvidersLoadingMore> get copyWith => _$ProvidersLoadingMoreCopyWithImpl<ProvidersLoadingMore>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProvidersLoadingMore&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'NetworkState.providersLoadingMore(data: $data)';
}


}

/// @nodoc
abstract mixin class $ProvidersLoadingMoreCopyWith<$Res> implements $NetworkStateCopyWith<$Res> {
  factory $ProvidersLoadingMoreCopyWith(ProvidersLoadingMore value, $Res Function(ProvidersLoadingMore) _then) = _$ProvidersLoadingMoreCopyWithImpl;
@useResult
$Res call({
 NetworkProviderData data
});




}
/// @nodoc
class _$ProvidersLoadingMoreCopyWithImpl<$Res>
    implements $ProvidersLoadingMoreCopyWith<$Res> {
  _$ProvidersLoadingMoreCopyWithImpl(this._self, this._then);

  final ProvidersLoadingMore _self;
  final $Res Function(ProvidersLoadingMore) _then;

/// Create a copy of NetworkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(ProvidersLoadingMore(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as NetworkProviderData,
  ));
}


}

/// @nodoc


class GovernmentsLoading implements NetworkState {
  const GovernmentsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GovernmentsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NetworkState.governmentsLoading()';
}


}




/// @nodoc


class GovernmentsSuccess implements NetworkState {
  const GovernmentsSuccess(final  List<Government> governments): _governments = governments;
  

 final  List<Government> _governments;
 List<Government> get governments {
  if (_governments is EqualUnmodifiableListView) return _governments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_governments);
}


/// Create a copy of NetworkState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GovernmentsSuccessCopyWith<GovernmentsSuccess> get copyWith => _$GovernmentsSuccessCopyWithImpl<GovernmentsSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GovernmentsSuccess&&const DeepCollectionEquality().equals(other._governments, _governments));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_governments));

@override
String toString() {
  return 'NetworkState.governmentsSuccess(governments: $governments)';
}


}

/// @nodoc
abstract mixin class $GovernmentsSuccessCopyWith<$Res> implements $NetworkStateCopyWith<$Res> {
  factory $GovernmentsSuccessCopyWith(GovernmentsSuccess value, $Res Function(GovernmentsSuccess) _then) = _$GovernmentsSuccessCopyWithImpl;
@useResult
$Res call({
 List<Government> governments
});




}
/// @nodoc
class _$GovernmentsSuccessCopyWithImpl<$Res>
    implements $GovernmentsSuccessCopyWith<$Res> {
  _$GovernmentsSuccessCopyWithImpl(this._self, this._then);

  final GovernmentsSuccess _self;
  final $Res Function(GovernmentsSuccess) _then;

/// Create a copy of NetworkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? governments = null,}) {
  return _then(GovernmentsSuccess(
null == governments ? _self._governments : governments // ignore: cast_nullable_to_non_nullable
as List<Government>,
  ));
}


}

/// @nodoc


class GovernmentsError implements NetworkState {
  const GovernmentsError(this.error);
  

 final  String error;

/// Create a copy of NetworkState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GovernmentsErrorCopyWith<GovernmentsError> get copyWith => _$GovernmentsErrorCopyWithImpl<GovernmentsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GovernmentsError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'NetworkState.governmentsError(error: $error)';
}


}

/// @nodoc
abstract mixin class $GovernmentsErrorCopyWith<$Res> implements $NetworkStateCopyWith<$Res> {
  factory $GovernmentsErrorCopyWith(GovernmentsError value, $Res Function(GovernmentsError) _then) = _$GovernmentsErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class _$GovernmentsErrorCopyWithImpl<$Res>
    implements $GovernmentsErrorCopyWith<$Res> {
  _$GovernmentsErrorCopyWithImpl(this._self, this._then);

  final GovernmentsError _self;
  final $Res Function(GovernmentsError) _then;

/// Create a copy of NetworkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(GovernmentsError(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class CitiesLoading implements NetworkState {
  const CitiesLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CitiesLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NetworkState.citiesLoading()';
}


}




/// @nodoc


class CitiesSuccess implements NetworkState {
  const CitiesSuccess(final  List<City> cities): _cities = cities;
  

 final  List<City> _cities;
 List<City> get cities {
  if (_cities is EqualUnmodifiableListView) return _cities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cities);
}


/// Create a copy of NetworkState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CitiesSuccessCopyWith<CitiesSuccess> get copyWith => _$CitiesSuccessCopyWithImpl<CitiesSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CitiesSuccess&&const DeepCollectionEquality().equals(other._cities, _cities));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_cities));

@override
String toString() {
  return 'NetworkState.citiesSuccess(cities: $cities)';
}


}

/// @nodoc
abstract mixin class $CitiesSuccessCopyWith<$Res> implements $NetworkStateCopyWith<$Res> {
  factory $CitiesSuccessCopyWith(CitiesSuccess value, $Res Function(CitiesSuccess) _then) = _$CitiesSuccessCopyWithImpl;
@useResult
$Res call({
 List<City> cities
});




}
/// @nodoc
class _$CitiesSuccessCopyWithImpl<$Res>
    implements $CitiesSuccessCopyWith<$Res> {
  _$CitiesSuccessCopyWithImpl(this._self, this._then);

  final CitiesSuccess _self;
  final $Res Function(CitiesSuccess) _then;

/// Create a copy of NetworkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? cities = null,}) {
  return _then(CitiesSuccess(
null == cities ? _self._cities : cities // ignore: cast_nullable_to_non_nullable
as List<City>,
  ));
}


}

/// @nodoc


class CitiesError implements NetworkState {
  const CitiesError(this.error);
  

 final  String error;

/// Create a copy of NetworkState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CitiesErrorCopyWith<CitiesError> get copyWith => _$CitiesErrorCopyWithImpl<CitiesError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CitiesError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'NetworkState.citiesError(error: $error)';
}


}

/// @nodoc
abstract mixin class $CitiesErrorCopyWith<$Res> implements $NetworkStateCopyWith<$Res> {
  factory $CitiesErrorCopyWith(CitiesError value, $Res Function(CitiesError) _then) = _$CitiesErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class _$CitiesErrorCopyWithImpl<$Res>
    implements $CitiesErrorCopyWith<$Res> {
  _$CitiesErrorCopyWithImpl(this._self, this._then);

  final CitiesError _self;
  final $Res Function(CitiesError) _then;

/// Create a copy of NetworkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(CitiesError(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class LocationLoading implements NetworkState {
  const LocationLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NetworkState.locationLoading()';
}


}




/// @nodoc


class LocationSuccess implements NetworkState {
  const LocationSuccess(this.latitude, this.longitude);
  

 final  double latitude;
 final  double longitude;

/// Create a copy of NetworkState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationSuccessCopyWith<LocationSuccess> get copyWith => _$LocationSuccessCopyWithImpl<LocationSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationSuccess&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude);

@override
String toString() {
  return 'NetworkState.locationSuccess(latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class $LocationSuccessCopyWith<$Res> implements $NetworkStateCopyWith<$Res> {
  factory $LocationSuccessCopyWith(LocationSuccess value, $Res Function(LocationSuccess) _then) = _$LocationSuccessCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class _$LocationSuccessCopyWithImpl<$Res>
    implements $LocationSuccessCopyWith<$Res> {
  _$LocationSuccessCopyWithImpl(this._self, this._then);

  final LocationSuccess _self;
  final $Res Function(LocationSuccess) _then;

/// Create a copy of NetworkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(LocationSuccess(
null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class LocationError implements NetworkState {
  const LocationError(this.error);
  

 final  String error;

/// Create a copy of NetworkState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationErrorCopyWith<LocationError> get copyWith => _$LocationErrorCopyWithImpl<LocationError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'NetworkState.locationError(error: $error)';
}


}

/// @nodoc
abstract mixin class $LocationErrorCopyWith<$Res> implements $NetworkStateCopyWith<$Res> {
  factory $LocationErrorCopyWith(LocationError value, $Res Function(LocationError) _then) = _$LocationErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class _$LocationErrorCopyWithImpl<$Res>
    implements $LocationErrorCopyWith<$Res> {
  _$LocationErrorCopyWithImpl(this._self, this._then);

  final LocationError _self;
  final $Res Function(LocationError) _then;

/// Create a copy of NetworkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(LocationError(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class LocationPermissionDenied implements NetworkState {
  const LocationPermissionDenied();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationPermissionDenied);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NetworkState.locationPermissionDenied()';
}


}




// dart format on
