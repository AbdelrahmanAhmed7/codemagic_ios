import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mediconsult/features/network/data/network_category_response_model.dart';
import 'package:mediconsult/features/network/data/network_provider_response_model.dart';
import 'package:mediconsult/features/network/data/government_response_model.dart';
import 'package:mediconsult/features/network/data/city_response_model.dart';

part 'network_state.freezed.dart';

@freezed
class NetworkState with _$NetworkState {
  const factory NetworkState.initial() = _Initial;
  
  // Categories states
  const factory NetworkState.categoriesLoading() = CategoriesLoading;
  const factory NetworkState.categoriesSuccess(List<NetworkCategory> categories) = CategoriesSuccess;
  const factory NetworkState.categoriesError(String error) = CategoriesError;
  
  // Providers states
  const factory NetworkState.providersLoading() = ProvidersLoading;
  const factory NetworkState.providersSuccess(NetworkProviderData data) = ProvidersSuccess;
  const factory NetworkState.providersError(String error) = ProvidersError;
  const factory NetworkState.providersEmpty() = ProvidersEmpty;
  const factory NetworkState.providersLoadingMore(NetworkProviderData data) = ProvidersLoadingMore;
  
  // Governments states
  const factory NetworkState.governmentsLoading() = GovernmentsLoading;
  const factory NetworkState.governmentsSuccess(List<Government> governments) = GovernmentsSuccess;
  const factory NetworkState.governmentsError(String error) = GovernmentsError;
  
  // Cities states
  const factory NetworkState.citiesLoading() = CitiesLoading;
  const factory NetworkState.citiesSuccess(List<City> cities) = CitiesSuccess;
  const factory NetworkState.citiesError(String error) = CitiesError;
  
  // Location states
  const factory NetworkState.locationLoading() = LocationLoading;
  const factory NetworkState.locationSuccess(double latitude, double longitude) = LocationSuccess;
  const factory NetworkState.locationError(String error) = LocationError;
  const factory NetworkState.locationPermissionDenied() = LocationPermissionDenied;
}
