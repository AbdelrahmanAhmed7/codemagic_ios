import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mediconsult/core/cache/cache_service.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/network/data/city_response_model.dart';
import 'package:mediconsult/features/network/data/government_response_model.dart';
import 'package:mediconsult/features/network/data/network_category_response_model.dart';
import 'package:mediconsult/features/network/data/network_provider_response_model.dart'
    as provider_model;
import 'package:mediconsult/features/network/logic/network_state.dart';
import 'package:mediconsult/features/network/repository/network_repository.dart';
import 'package:mediconsult/shared/widgets/location_permission_dialog.dart';
import 'package:mediconsult/core/services/firebase_crashlytics_service.dart';

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

  /// Get all categories with caching
  Future<void> getCategories({BuildContext? context, String? lang, bool forceRefresh = false}) async {
    emit(const NetworkState.categoriesLoading());

    final String language = context != null
        ? context.locale.languageCode
        : (lang ?? 'en');

    // Try cache first if not forcing refresh
    if (!forceRefresh) {
      final cachedData = await CacheService.getCachedNetworkCategoriesData();
      if (cachedData != null) {
        try {
          final response = NetworkCategoryResponse.fromJson(cachedData);
          if (response.success && response.data.categories.isNotEmpty) {
            _categories = response.data.categories;
            emit(NetworkState.categoriesSuccess(_categories));
            
            // Background refresh
            unawaited(_fetchAndCacheCategories(language));
            return;
          }
        } catch (e) {
          // If cache parsing fails, continue to fetch from API
        }
      }
    }

    await _fetchAndCacheCategories(language);
  }

  Future<void> _fetchAndCacheCategories(String language) async {
    final result = await _repository.getCategories(language);

    result.when(
      success: (response) async {
        _categories = response.data.categories;
        emit(NetworkState.categoriesSuccess(_categories));
        // Cache the response
        await CacheService.cacheNetworkCategoriesData(response.toJson());
      },
      failure: (message) {
        // تسجيل فشل تحميل فئات مقدمي الخدمة
        FirebaseCrashlyticsService.instance.recordError(
          exception: 'Network Categories Load Failed: $message',
          reason: 'Failed to load network categories',
          information: ['Language: $language'],
        );
        
        emit(NetworkState.categoriesError(message));
      },
    );
  }

  /// Show location permission dialog and handle user response
  /// Only shows dialog if permission is not already granted
  /// Handles "Allow Once" case: if permission was granted but now denied, it means "Allow Once" expired
  Future<void> requestLocationWithDialog(BuildContext context) async {
    // Check permission status first
    LocationPermission permission = await Geolocator.checkPermission();
    
    // If permission is already granted (whileInUse or always), get location directly
    if (permission == LocationPermission.whileInUse || 
        permission == LocationPermission.always) {
      // Permission already granted, get location directly
      await getUserLocation();
      // If location retrieved successfully, load providers
      if (_userLatitude != null && _userLongitude != null) {
        await searchProviders(resetPage: true, context: context);
      } else {
        // Location failed, load random providers
        _loadRandomProviders(context);
      }
      return;
    }
    
    // If permission is denied forever, don't show dialog again
    if (permission == LocationPermission.deniedForever) {
      _loadRandomProviders(context);
      return;
    }
    
    // Permission is denied or not determined
    // This could be:
    // 1. First time asking for permission
    // 2. User chose "Allow Once" previously and it expired
    // 3. User denied permission previously
    
    // Clear any cached location data (in case "Allow Once" expired)
    if (permission == LocationPermission.denied && 
        (_userLatitude != null || _userLongitude != null)) {
      // Likely "Allow Once" expired, clear cached location
      _userLatitude = null;
      _userLongitude = null;
    }
    
    // Show dialog to request permission
    await LocationPermissionDialog.show(
      context,
      onEnablePressed: () async {
        // User chose to enable location access
        // This will show system dialog where user can choose:
        // - Allow all the time
        // - Allow only while using the app
        // - Allow once (Android) / Ask each time (iOS)
        await getUserLocation();
        // If location retrieved successfully, load providers
        if (_userLatitude != null && _userLongitude != null) {
          await searchProviders(resetPage: true, context: context);
        } else {
          // Location failed, load random providers
          _loadRandomProviders(context);
        }
      },
      onMaybeLaterPressed: () {
        // User chose maybe later - load random providers
        _loadRandomProviders(context);
      },
    );
  }

  /// Load random providers when user declines location access
  Future<void> _loadRandomProviders(BuildContext context) async {
    // Clear location data
    _userLatitude = null;
    _userLongitude = null;
    
    // Search providers without location (will get random results)
    await searchProviders(resetPage: true, context: context);
  }

  /// Get user's current location
  Future<void> getUserLocation() async {
    emit(const NetworkState.locationLoading());

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        // Try to open location settings
        serviceEnabled = await Geolocator.openLocationSettings();
        if (!serviceEnabled) {
          emit(
            const NetworkState.locationError('Location services are disabled'),
          );
          return;
        }
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();

      // Handle "Allow Once" case: if permission was granted before but now is denied,
      // it means user chose "Allow Once" previously
      if (permission == LocationPermission.denied) {
        // Check if we have cached location from previous "Allow Once" session
        // If not, request permission again (user might choose "Allow Once" again or grant permanently)
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

      // Get current position with timeout
      // This will work even if user chose "Allow Once" (as long as permission is still valid)
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10), // Add timeout
        ),
      );

      _userLatitude = position.latitude;
      _userLongitude = position.longitude;

      emit(NetworkState.locationSuccess(position.latitude, position.longitude));
    } catch (e, stackTrace) {
      // Check if error is due to permission being revoked (Allow Once expired)
      LocationPermission currentPermission = await Geolocator.checkPermission();
      
      if (currentPermission == LocationPermission.denied) {
        // Permission was revoked (likely "Allow Once" expired)
        // Clear cached location
        _userLatitude = null;
        _userLongitude = null;
        emit(const NetworkState.locationPermissionDenied());
        return;
      }
      
      // تسجيل خطأ الموقع في Crashlytics
      FirebaseCrashlyticsService.instance.recordError(
        exception: e,
        stackTrace: stackTrace,
        reason: 'Failed to get user location',
        information: [
          'Location Services Enabled: ${await Geolocator.isLocationServiceEnabled()}',
          'Permission Status: ${await Geolocator.checkPermission()}',
        ],
      );
      
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
    bool ensureEmptyResults = false,
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
          // إذا كانت البيانات فارغة من API
          // حفظ البيانات الفارغة مع معلومات الفلترة
          if (response.data != null) {
            _currentProviderData = provider_model.NetworkProviderData(
              categories: response.data!.categories,
              providers: [], // قائمة فارغة
              pagination: response.data!.pagination,
              userLocation: response.data!.userLocation,
              searchTerm: response.data!.searchTerm,
              categoryId: categoryId,
              governmentId: governmentId,
              cityId: cityId,
            );
          }
          // إظهار حالة "لا توجد نتائج"
          emit(const NetworkState.providersEmpty());
        } else {
          // إذا كانت هناك نتائج
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

  /// Get all governments with caching
  Future<void> getGovernments({BuildContext? context, String? lang, bool forceRefresh = false}) async {
    emit(const NetworkState.governmentsLoading());

    final String language = context != null
        ? context.locale.languageCode
        : (lang ?? 'en');

    // Try cache first if not forcing refresh
    if (!forceRefresh) {
      final cachedData = await CacheService.getCachedNetworkGovernmentsData();
      if (cachedData != null) {
        try {
          final response = GovernmentResponse.fromJson(cachedData);
          if (response.success && response.data.governments.isNotEmpty) {
            _governments = response.data.governments;
            emit(NetworkState.governmentsSuccess(_governments));
            
            // Background refresh
            unawaited(_fetchAndCacheGovernments(language));
            return;
          }
        } catch (e) {
          // If cache parsing fails, continue to fetch from API
        }
      }
    }

    await _fetchAndCacheGovernments(language);
  }

  Future<void> _fetchAndCacheGovernments(String language) async {
    final result = await _repository.getGovernments(
      language,
      page: 1,
      pageSize: 100,
    );

    result.when(
      success: (response) async {
        _governments = response.data.governments;
        emit(NetworkState.governmentsSuccess(_governments));
        // Cache the response
        await CacheService.cacheNetworkGovernmentsData(response.toJson());
      },
      failure: (message) {
        emit(NetworkState.governmentsError(message));
      },
    );
  }

  /// Get cities by government with caching
  Future<void> getCitiesByGovernment(
    int governmentId, {
    BuildContext? context,
    String? lang,
    bool forceRefresh = false,
  }) async {
    emit(const NetworkState.citiesLoading());
    final String language = context != null
        ? context.locale.languageCode
        : (lang ?? 'en');

    // Try cache first if not forcing refresh
    if (!forceRefresh) {
      final cachedData = await CacheService.getCachedNetworkCitiesData(governmentId);
      if (cachedData != null) {
        try {
          final response = CityResponse.fromJson(cachedData);
          if (response.success && response.data != null && response.data!.cities.isNotEmpty) {
            _cities = response.data!.cities;
            emit(NetworkState.citiesSuccess(_cities));
            
            // Background refresh
            unawaited(_fetchAndCacheCities(language, governmentId));
            return;
          }
        } catch (e) {
          // If cache parsing fails, continue to fetch from API
        }
      }
    }

    await _fetchAndCacheCities(language, governmentId);
  }

  Future<void> _fetchAndCacheCities(String language, int governmentId) async {
    final result = await _repository.getCitiesByGovernment(
      language,
      governmentId: governmentId,
      page: 1,
      pageSize: 100,
    );

    result.when(
      success: (response) async {
        _cities = response.data?.cities ?? [];
        emit(NetworkState.citiesSuccess(_cities));
        // Cache the response
        if (response.data != null) {
          await CacheService.cacheNetworkCitiesData(governmentId, response.toJson());
        }
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
