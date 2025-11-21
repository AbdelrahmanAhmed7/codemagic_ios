# Network Feature Documentation

## Overview
The Network feature allows users to search and find healthcare providers (hospitals, clinics, labs, etc.) on a map or in a list view. Users can filter by category, government, and city, and view provider details including location, contact information, and distance from their current location.

## Feature Structure

```
lib/features/network/
├── data/
│   ├── city_response_model.dart
│   ├── government_response_model.dart
│   ├── network_category_response_model.dart
│   └── network_provider_response_model.dart
├── service/
│   └── network_api_service.dart
├── repository/
│   └── network_repository.dart
├── logic/
│   ├── network_cubit.dart
│   └── network_state.dart
└── presentation/
    ├── network_screen.dart
    └── widgets/
        ├── network_categories_list.dart
        ├── network_filter_bottom_sheet.dart
        ├── provider_card.dart
        ├── providers_map_view.dart
        └── empty_providers_state.dart
```

## Components

### 1. Data Models
- **NetworkCategory**: Category information (id, name, image)
- **NetworkProvider**: Provider details (name, location, contact, distance)
- **Government**: Government/state information
- **City**: City information linked to governments
- **UserLocation**: User's GPS coordinates
- **Pagination**: Pagination metadata

### 2. API Service (Retrofit)
**Endpoints:**
- `GET /Network/GetCategories` - Fetch all provider categories
- `GET /Network/Search` - Search providers with filters
- `GET /Network/GetGovernments` - Fetch all governments
- `GET /Network/GetCities` - Fetch cities by government

### 3. Repository Layer
Handles API calls and error handling using `ApiResult<T>` pattern.

### 4. Business Logic (Cubit)
**NetworkCubit** manages:
- Categories loading and caching
- Provider search with filters
- Location services (GPS)
- Pagination
- Filter state management

**Key Methods:**
- `getCategories()` - Load provider categories
- `getUserLocation()` - Get user's GPS location
- `searchProviders()` - Search with filters
- `loadMoreProviders()` - Pagination
- `getGovernments()` - Load governments
- `getCitiesByGovernment()` - Load cities
- `clearFilters()` - Reset all filters

### 5. UI Components

#### NetworkScreen
Main screen with:
- Categories horizontal list
- Search bar with filter button
- Two tabs: Map view and Near Me List
- Pull-to-refresh
- Infinite scroll pagination

#### NetworkCategoriesList
Horizontal scrollable list of categories with icons.

#### NetworkFilterBottomSheet
Bottom sheet for filtering by:
- Government (محافظة)
- City (مدينة)

#### ProviderCard
Card displaying provider information:
- Logo
- Name and category
- Location and distance
- Phone number with call button

#### ProvidersMapView
Interactive map using flutter_map:
- User location marker (blue)
- Provider markers (red/green)
- Tap to select provider
- Recenter button

#### EmptyProvidersState
Empty state illustration when no providers found.

## Dependencies Added

```yaml
dependencies:
  flutter_map: ^8.2.2      # Map widget
  latlong2: ^0.9.1         # Latitude/Longitude
  geolocator: ^13.0.2      # GPS location
  url_launcher: ^6.3.1     # Phone calls
```

## Usage

### Navigation
The feature is accessible via:
1. Bottom Navigation Bar - "Provider" button (index 1)
2. Direct route: `/network`

### Dependency Injection
Registered in `service_locator.dart`:
```dart
// Service
sl.registerLazySingleton<NetworkApiService>(() => NetworkApiService(dio));

// Repository
sl.registerLazySingleton<NetworkRepository>(() => NetworkRepository(sl()));

// Cubit
sl.registerFactory<NetworkCubit>(() => NetworkCubit(sl()));
```

### Router Configuration
```dart
GoRoute(
  path: '/network',
  builder: (context, state) {
    return BlocProvider(
      create: (context) => sl<NetworkCubit>(),
      child: const NetworkScreen(),
    );
  },
),
```

## Features Implemented

✅ **Categories Display**
- Horizontal scrollable list
- Category icons
- Selection state

✅ **Search & Filter**
- Text search
- Category filter
- Government filter
- City filter (dependent on government)
- Filter indicator badge

✅ **Map View**
- OpenStreetMap tiles
- User location marker
- Provider markers
- Marker selection
- Zoom and pan
- Recenter button

✅ **List View**
- Provider cards
- Distance display
- Call button
- Pull-to-refresh
- Infinite scroll

✅ **Location Services**
- GPS permission handling
- User location tracking
- Distance calculation

✅ **State Management**
- Loading states
- Error handling
- Empty states
- Pagination state

## Testing

To test the feature:
1. Run `flutter pub get`
2. Run `dart run build_runner build --delete-conflicting-outputs`
3. Navigate to the app and tap "Provider" in bottom navigation
4. Grant location permissions when prompted
5. Test search, filters, and map interactions

## API Requirements

Ensure the backend provides these endpoints:
- `GET /en/Network/GetCategories`
- `GET /en/Network/Search?key=&categoryId=&governmentId=&cityId=&latitude=&longitude=&page=&pageSize=`
- `GET /en/Network/GetGovernments?page=&pageSize=`
- `GET /en/Network/GetCities?governmentId=&page=&pageSize=`

## Notes

- The feature uses clean architecture pattern
- All states are managed using BLoC/Cubit
- API responses are cached in the Cubit
- Location permissions must be granted for distance calculation
- Map requires internet connection for tiles
- Phone calls use `url_launcher` package

## Future Enhancements

Potential improvements:
- [ ] Provider details screen
- [ ] Directions to provider
- [ ] Favorite providers
- [ ] Recent searches
- [ ] Offline map caching
- [ ] Provider ratings and reviews
- [ ] Appointment booking integration
