import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/network/data/city_response_model.dart';
import 'package:mediconsult/features/network/data/government_response_model.dart';
import 'package:mediconsult/features/network/data/network_category_response_model.dart';
import 'package:mediconsult/features/network/data/network_provider_response_model.dart'
    as provider_model;
import 'package:mediconsult/features/network/logic/network_state.dart';
import 'package:mediconsult/features/network/repository/network_repository.dart';

class NetworkCubit extends Cubit<NetworkState> {
  final NetworkRepository _repository;

  // Cache data
  List<NetworkCategory> _categories = [];
  List<Government> _governments = [];
  List<City> _cities = [];
  provider_model.NetworkProviderData? _currentProviderData;

  // Current filters
  String? _searchKey;
  int? _selectedCategoryId;
  int? _selectedGovernmentId;
  int? _selectedCityId;
  double? _userLatitude;
  double? _userLongitude;

  // Pagination
  int _currentPage = 1;
  static const int _pageSize = 20;

  NetworkCubit(this._repository) : super(const NetworkState.initial());

  // Getters for cached data
  List<NetworkCategory> get categories => _categories;
  List<Government> get governments => _governments;
  List<City> get cities => _cities;
  provider_model.NetworkProviderData? get currentProviderData =>
      _currentProviderData;

  // Getters for filters
  String? get searchKey => _searchKey;
  int? get selectedCategoryId => _selectedCategoryId;
  int? get selectedGovernmentId => _selectedGovernmentId;
  int? get selectedCityId => _selectedCityId;
  double? get userLatitude => _userLatitude;
  double? get userLongitude => _userLongitude;
  List<provider_model.NetworkProvider> get currentProviders =>
      _currentProviderData?.providers ?? [];
  bool get hasActiveFilters =>
      _selectedCategoryId != null ||
      _selectedGovernmentId != null ||
      _selectedCityId != null ||
      (_searchKey != null && _searchKey!.isNotEmpty);

  /// Get all categories
 Future<void> getCategories({BuildContext? context, String? lang}) async {
  emit(const NetworkState.categoriesLoading());

  final String language = context != null 
      ? context.locale.languageCode 
      : (lang ?? 'en');

  final result = await _repository.getCategories(language);

  result.when(
    success: (response) {
      _categories = response.data.categories;
      emit(NetworkState.categoriesSuccess(_categories));
    },
    failure: (message) {
      emit(NetworkState.categoriesError(message));
    },
  );
}

  /// Get user's current location
  Future<void> getUserLocation() async {
    emit(const NetworkState.locationLoading());

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        emit(
          const NetworkState.locationError('Location services are disabled'),
        );
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          emit(const NetworkState.locationPermissionDenied());
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(const NetworkState.locationPermissionDenied());
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      _userLatitude = position.latitude;
      _userLongitude = position.longitude;

      emit(NetworkState.locationSuccess(position.latitude, position.longitude));
    } catch (e) {
      emit(NetworkState.locationError(e.toString()));
    }
  }

  /// Search providers with filters
  Future<void> searchProviders({
    String? searchKey,
    int? categoryId,
    int? governmentId,
    int? cityId,
    bool resetPage = true,
    String? lang,
    BuildContext? context,
  }) async {
    if (resetPage) {
      _currentPage = 1;
    }

    // Update filters
    _searchKey = searchKey;
    _selectedCategoryId = categoryId;
    _selectedGovernmentId = governmentId;
    _selectedCityId = cityId;

    emit(const NetworkState.providersLoading());
    
    // Use context.locale if context is provided, otherwise use provided lang or default to 'en'
    final String language = context != null 
        ? context.locale.languageCode 
        : (lang ?? 'en');

    final result = await _repository.searchProviders(
      language,
      searchKey: _searchKey,
      categoryId: _selectedCategoryId,
      governmentId: _selectedGovernmentId,
      cityId: _selectedCityId,
      latitude: _userLatitude,
      longitude: _userLongitude,
      page: _currentPage,
      pageSize: _pageSize,
    );

    result.when(
      success: (response) {
        if (response.data == null || response.data!.providers.isEmpty) {
          emit(const NetworkState.providersEmpty());
        } else {
          _currentProviderData = response.data;
          emit(NetworkState.providersSuccess(response.data!));
        }
      },
      failure: (message) {
        emit(NetworkState.providersError(message));
      },
    );
  }

  Future<void> loadMoreProviders({BuildContext? context, String? lang}) async {
    if (_currentProviderData == null ||
        !_currentProviderData!.pagination.hasNextPage) {
      return;
    }

    emit(NetworkState.providersLoadingMore(_currentProviderData!));

    _currentPage++;

    // Use context.locale if context is provided, otherwise use provided lang or default to 'en'
    final String language = context != null 
        ? context.locale.languageCode 
        : (lang ?? 'en');

    final result = await _repository.searchProviders(
      language,
      searchKey: _searchKey,
      categoryId: _selectedCategoryId,
      governmentId: _selectedGovernmentId,
      cityId: _selectedCityId,
      latitude: _userLatitude,
      longitude: _userLongitude,
      page: _currentPage,
      pageSize: _pageSize,
    );

    result.when(
      success: (response) {
        if (response.data != null) {
          // Merge providers
          final updatedProviders = [
            ..._currentProviderData!.providers,
            ...response.data!.providers,
          ];

          _currentProviderData = provider_model.NetworkProviderData(
            categories: response.data!.categories,
            providers: updatedProviders,
            pagination: response.data!.pagination,
            userLocation: response.data!.userLocation,
            searchTerm: response.data!.searchTerm,
            categoryId: response.data!.categoryId,
            governmentId: response.data!.governmentId,
            cityId: response.data!.cityId,
          );

          emit(NetworkState.providersSuccess(_currentProviderData!));
        }
      },
      failure: (message) {
        _currentPage--;
        emit(NetworkState.providersSuccess(_currentProviderData!));
      },
    );
  }

  /// Get all governments
  Future<void> getGovernments({BuildContext? context, String? lang}) async {
    emit(const NetworkState.governmentsLoading());

    // Use context.locale if context is provided, otherwise use provided lang or default to 'en'
    final String language = context != null 
        ? context.locale.languageCode 
        : (lang ?? 'en');

    final result = await _repository.getGovernments(
      language,
      page: 1,
      pageSize: 100,
    );

    result.when(
      success: (response) {
        _governments = response.data.governments;
        emit(NetworkState.governmentsSuccess(_governments));
      },
      failure: (message) {
        emit(NetworkState.governmentsError(message));
      },
    );
  }

  /// Get cities by government
  Future<void> getCitiesByGovernment(int governmentId, {BuildContext? context, String? lang}) async {
    emit(const NetworkState.citiesLoading());

    // Use context.locale if context is provided, otherwise use provided lang or default to 'en'
    final String language = context != null 
        ? context.locale.languageCode 
        : (lang ?? 'en');

    final result = await _repository.getCitiesByGovernment(
      language,
      governmentId: governmentId,
      page: 1,
      pageSize: 100,
    );

    result.when(
      success: (response) {
        _cities = response.data?.cities ?? [];
        emit(NetworkState.citiesSuccess(_cities));
      },
      failure: (message) {
        emit(NetworkState.citiesError(message));
      },
    );
  }

  /// Clear all filters
  void clearFilters() {
    _searchKey = null;
    _selectedCategoryId = null;
    _selectedGovernmentId = null;
    _selectedCityId = null;
    _cities = [];
    searchProviders(resetPage: true);
  }

  /// Clear specific filter
  void clearCategoryFilter() {
    _selectedCategoryId = null;
    searchProviders(resetPage: true);
  }

  void clearGovernmentFilter() {
    _selectedGovernmentId = null;
    _selectedCityId = null;
    _cities = [];
    searchProviders(resetPage: true);
  }

  void clearCityFilter() {
    _selectedCityId = null;
    searchProviders(resetPage: true);
  }

  /// Reset to initial state
  void reset() {
    _searchKey = null;
    _selectedCategoryId = null;
    _selectedGovernmentId = null;
    _selectedCityId = null;
    _currentPage = 1;
    _currentProviderData = null;
    emit(const NetworkState.initial());
  }
}
