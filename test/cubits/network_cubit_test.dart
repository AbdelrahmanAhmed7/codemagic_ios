import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mediconsult/features/network/logic/network_cubit.dart';
import 'package:mediconsult/features/network/logic/network_state.dart';
import 'package:mediconsult/features/network/repository/network_repository.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/network/data/network_category_response_model.dart';
import 'package:mediconsult/features/network/data/network_provider_response_model.dart' as provider;
import 'package:mediconsult/features/network/data/government_response_model.dart' as gov;
import 'package:mediconsult/features/network/data/city_response_model.dart' as city;

class MockNetworkRepository extends Mock implements NetworkRepository {}

NetworkCategoryResponse buildCategoriesResponse() => NetworkCategoryResponse(
      success: true,
      timestamp: 'now',
      message: 'ok',
      data: NetworkCategoryData(categories: const [], totalCount: 0),
    );

provider.NetworkProviderResponse buildProvidersEmptyResponse() => provider.NetworkProviderResponse(
      success: true,
      timestamp: 'now',
      message: 'ok',
      data: provider.NetworkProviderData(
        categories: const [],
        providers: const [],
        pagination: provider.Pagination(
          currentPage: 1,
          pageSize: 20,
          totalCount: 0,
          totalPages: 0,
          hasNextPage: false,
          hasPreviousPage: false,
        ),
        userLocation: null,
        searchTerm: null,
        categoryId: null,
        governmentId: null,
        cityId: null,
      ),
    );

provider.NetworkProviderResponse buildProvidersPage({required int page, required int count}) => provider.NetworkProviderResponse(
      success: true,
      timestamp: 'now',
      message: 'ok',
      data: provider.NetworkProviderData(
        categories: const [],
        providers: List.generate(count, (i) => provider.NetworkProvider(
          providerId: i + (page - 1) * count + 1,
          locationId: 1,
          providerName: 'P${i + 1}-p$page',
          providerLogo: '',
          categoryName: 'cat',
          latitude: 0,
          longitude: 0,
          government: 'g',
          city: 'c',
          area: 'a',
          address: 'addr',
          fullAddress: 'full',
          mapsUrl: 'url',
          mobile: '010',
          hotline: '',
        )),
        pagination: provider.Pagination(
          currentPage: page,
          pageSize: count,
          totalCount: 2 * count,
          totalPages: 2,
          hasNextPage: page < 2,
          hasPreviousPage: page > 1,
        ),
        userLocation: null,
        searchTerm: null,
        categoryId: null,
        governmentId: null,
        cityId: null,
      ),
    );

gov.GovernmentResponse buildGovernmentsResponse() => gov.GovernmentResponse(
      success: true,
      timestamp: 'now',
      message: 'ok',
      data: gov.GovernmentData(
        governments: const [],
        pagination: gov.Pagination(
          currentPage: 1,
          pageSize: 100,
          totalCount: 0,
          totalPages: 0,
          hasNextPage: false,
          hasPreviousPage: false,
        ),
      ),
    );

city.CityResponse buildCitiesResponse() => city.CityResponse(
      success: true,
      timestamp: 'now',
      message: 'ok',
      data: city.CityData(
        cities: const [],
        pagination: city.Pagination(
          currentPage: 1,
          pageSize: 100,
          totalCount: 0,
          totalPages: 0,
          hasNextPage: false,
          hasPreviousPage: false,
        ),
        filter: city.CityFilter(governmentId: 1),
      ),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockNetworkRepository repo;
  late NetworkCubit cubit;

  setUp(() {
    repo = MockNetworkRepository();
    cubit = NetworkCubit(repo);
  });

  tearDown(() async {
    await cubit.close();
  });

  blocTest<NetworkCubit, NetworkState>(
    'getCategories emits loading then success',
    build: () {
      when(() => repo.getCategories(any())).thenAnswer((_) async => ApiResult.success(buildCategoriesResponse()));
      return cubit;
    },
    act: (c) => c.getCategories(lang: 'ar', forceRefresh: true),
    expect: () => [
      const NetworkState.categoriesLoading(),
      isA<NetworkState>().having((s) => s.maybeMap(categoriesSuccess: (_) => true, orElse: () => false), 'categoriesSuccess', true),
    ],
  );

  blocTest<NetworkCubit, NetworkState>(
    'getCategories emits loading then error on failure',
    build: () {
      when(() => repo.getCategories(any())).thenAnswer((_) async => const ApiResult.failure('err'));
      return cubit;
    },
    act: (c) => c.getCategories(lang: 'ar', forceRefresh: true),
    expect: () => [
      const NetworkState.categoriesLoading(),
      isA<NetworkState>().having((s) => s.maybeMap(categoriesError: (_) => true, orElse: () => false), 'categoriesError', true),
    ],
  );

  blocTest<NetworkCubit, NetworkState>(
    'searchProviders emits loading then empty when no results',
    build: () {
      when(() => repo.searchProviders(any(),
              searchKey: any(named: 'searchKey'),
              categoryId: any(named: 'categoryId'),
              governmentId: any(named: 'governmentId'),
              cityId: any(named: 'cityId'),
              latitude: any(named: 'latitude'),
              longitude: any(named: 'longitude'),
              page: any(named: 'page'),
              pageSize: any(named: 'pageSize')))
          .thenAnswer((_) async => ApiResult.success(buildProvidersEmptyResponse()));
      return cubit;
    },
    act: (c) => c.searchProviders(lang: 'ar', searchKey: 'x'),
    expect: () => [
      const NetworkState.providersLoading(),
      const NetworkState.providersEmpty(),
    ],
  );

  blocTest<NetworkCubit, NetworkState>(
    'loadMoreProviders appends providers on success',
    build: () {
      when(() => repo.searchProviders(any(),
              searchKey: any(named: 'searchKey'),
              categoryId: any(named: 'categoryId'),
              governmentId: any(named: 'governmentId'),
              cityId: any(named: 'cityId'),
              latitude: any(named: 'latitude'),
              longitude: any(named: 'longitude'),
              page: any(named: 'page'),
              pageSize: any(named: 'pageSize')))
          .thenAnswer((invocation) async {
        final page = invocation.namedArguments[const Symbol('page')] as int? ?? 1;
        return ApiResult.success(
          page == 1 ? buildProvidersPage(page: 1, count: 2) : buildProvidersPage(page: 2, count: 2),
        );
      });
      return cubit;
    },
    act: (c) async {
      await c.searchProviders(lang: 'ar');
      await c.loadMoreProviders(lang: 'ar');
    },
    expect: () => [
      const NetworkState.providersLoading(),
      isA<NetworkState>().having((s) => s.maybeMap(providersSuccess: (_) => true, orElse: () => false), 'providersSuccess page1', true),
      isA<NetworkState>().having((s) => s.maybeMap(providersLoadingMore: (_) => true, orElse: () => false), 'loadingMore', true),
      isA<NetworkState>().having((s) => s.maybeMap(providersSuccess: (_) => true, orElse: () => false), 'providersSuccess merged', true),
    ],
  );

  blocTest<NetworkCubit, NetworkState>(
    'loadMoreProviders keeps previous data on failure',
    build: () {
      // First page success
      when(() => repo.searchProviders(any(),
              searchKey: any(named: 'searchKey'),
              categoryId: any(named: 'categoryId'),
              governmentId: any(named: 'governmentId'),
              cityId: any(named: 'cityId'),
              latitude: any(named: 'latitude'),
              longitude: any(named: 'longitude'),
              page: 1,
              pageSize: any(named: 'pageSize')))
          .thenAnswer((_) async => ApiResult.success(buildProvidersPage(page: 1, count: 2)));
      // Second page failure
      when(() => repo.searchProviders(any(),
              searchKey: any(named: 'searchKey'),
              categoryId: any(named: 'categoryId'),
              governmentId: any(named: 'governmentId'),
              cityId: any(named: 'cityId'),
              latitude: any(named: 'latitude'),
              longitude: any(named: 'longitude'),
              page: 2,
              pageSize: any(named: 'pageSize')))
          .thenAnswer((_) async => const ApiResult.failure('err'));
      return cubit;
    },
    act: (c) async {
      await c.searchProviders(lang: 'ar');
      await c.loadMoreProviders(lang: 'ar');
    },
    expect: () => [
      const NetworkState.providersLoading(),
      isA<NetworkState>().having((s) => s.maybeMap(providersSuccess: (_) => true, orElse: () => false), 'providersSuccess page1', true),
      isA<NetworkState>().having((s) => s.maybeMap(providersLoadingMore: (_) => true, orElse: () => false), 'loadingMore', true),
      isA<NetworkState>().having((s) => s.maybeMap(providersSuccess: (_) => true, orElse: () => false), 'providersSuccess unchanged', true),
    ],
  );

  blocTest<NetworkCubit, NetworkState>(
    'getGovernments emits loading then error on failure',
    build: () {
      when(() => repo.getGovernments(any(), page: any(named: 'page'), pageSize: any(named: 'pageSize')))
          .thenAnswer((_) async => const ApiResult.failure('fail'));
      return cubit;
    },
    act: (c) => c.getGovernments(lang: 'ar', forceRefresh: true),
    expect: () => [
      const NetworkState.governmentsLoading(),
      isA<NetworkState>().having((s) => s.maybeMap(governmentsError: (_) => true, orElse: () => false), 'governmentsError', true),
    ],
  );

  blocTest<NetworkCubit, NetworkState>(
    'getCitiesByGovernment emits loading then error on failure',
    build: () {
      when(() => repo.getCitiesByGovernment(any(), governmentId: any(named: 'governmentId'), page: any(named: 'page'), pageSize: any(named: 'pageSize')))
          .thenAnswer((_) async => const ApiResult.failure('fail'));
      return cubit;
    },
    act: (c) => c.getCitiesByGovernment(1, lang: 'ar', forceRefresh: true),
    expect: () => [
      const NetworkState.citiesLoading(),
      isA<NetworkState>().having((s) => s.maybeMap(citiesError: (_) => true, orElse: () => false), 'citiesError', true),
    ],
  );

  blocTest<NetworkCubit, NetworkState>(
    'clearFilters triggers providers reload to empty',
    build: () {
      when(() => repo.searchProviders(any(),
              searchKey: any(named: 'searchKey'),
              categoryId: any(named: 'categoryId'),
              governmentId: any(named: 'governmentId'),
              cityId: any(named: 'cityId'),
              latitude: any(named: 'latitude'),
              longitude: any(named: 'longitude'),
              page: any(named: 'page'),
              pageSize: any(named: 'pageSize')))
          .thenAnswer((_) async => ApiResult.success(buildProvidersEmptyResponse()));
      return cubit;
    },
    act: (c) async {
      await c.searchProviders(lang: 'ar', searchKey: 'abc');
      c.clearFilters();
    },
    expect: () => [
      const NetworkState.providersLoading(),
      const NetworkState.providersEmpty(),
      const NetworkState.providersLoading(),
      const NetworkState.providersEmpty(),
    ],
  );

  blocTest<NetworkCubit, NetworkState>(
    'getGovernments emits loading then success',
    build: () {
      when(() => repo.getGovernments(any(), page: any(named: 'page'), pageSize: any(named: 'pageSize')))
          .thenAnswer((_) async => ApiResult.success(buildGovernmentsResponse()));
      return cubit;
    },
    act: (c) => c.getGovernments(lang: 'ar', forceRefresh: true),
    expect: () => [
      const NetworkState.governmentsLoading(),
      isA<NetworkState>().having((s) => s.maybeMap(governmentsSuccess: (_) => true, orElse: () => false), 'governmentsSuccess', true),
    ],
  );

  blocTest<NetworkCubit, NetworkState>(
    'getCitiesByGovernment emits loading then success',
    build: () {
      when(() => repo.getCitiesByGovernment(any(), governmentId: any(named: 'governmentId'), page: any(named: 'page'), pageSize: any(named: 'pageSize')))
          .thenAnswer((_) async => ApiResult.success(buildCitiesResponse()));
      return cubit;
    },
    act: (c) => c.getCitiesByGovernment(1, lang: 'ar', forceRefresh: true),
    expect: () => [
      const NetworkState.citiesLoading(),
      isA<NetworkState>().having((s) => s.maybeMap(citiesSuccess: (_) => true, orElse: () => false), 'citiesSuccess', true),
    ],
  );
}


