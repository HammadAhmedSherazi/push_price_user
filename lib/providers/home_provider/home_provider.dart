import 'dart:async';

import 'package:push_price_user/export_all.dart';

import '../../data/network/api_response.dart';
import 'home_state.dart';



class HomeProvider extends Notifier<HomeState> {
  @override
  HomeState build() {
    return HomeState(
      getCategoriesApiResponse: ApiResponse.undertermined(),
      categories: [],
      chainId: null,
      getStoresApiResponse: ApiResponse.undertermined(),
      stores: [],
      storesSkip: 0,
      getNearbyStoresApiResponse: ApiResponse.undertermined(),
      nearbyStores: [],
      nearbyStoresSkip: 0,
    );
  }

  FutureOr<void> getCategories({int? chainId}) async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(getCategoriesApiResponse: ApiResponse.loading());
      Map<String, dynamic> params = {};
      if (chainId != null) {
        params['chain_id'] = chainId;
      }

      final response = await MyHttpClient.instance.get(
        ApiEndpoints.getCatrgories,
        params: params,
      );

      if (!ref.mounted) return;

      if (response != null) {
        List temp = response ?? [];
        final List<CategoryDataModel> list = List.from(
          temp.map((e) => CategoryDataModel.fromJson(e)),
        );
        state = state.copyWith(
          getCategoriesApiResponse: ApiResponse.completed(response),
          categories: list,
          chainId: chainId,
        );
      } else {
        state = state.copyWith(
          getCategoriesApiResponse: ApiResponse.error(),
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        getCategoriesApiResponse: ApiResponse.error(),
      );
    }
  }

  FutureOr<void> getStores({
    required int limit,
    required int skip,
    int? chainId,
    String? search,
  }) async {
    if (!ref.mounted) return;
    if (skip == 0 && state.stores!.isNotEmpty) {
      state = state.copyWith(stores: [], storesSkip: 0);
    }
    Map<String, dynamic> params = {'limit': limit, 'skip': skip};
    if (search != null) {
      params['search'] = search;
    }
    if (chainId != null) {
      params['chain_id'] = chainId;
    }

    try {
      state = state.copyWith(
        getStoresApiResponse: skip == 0
            ? ApiResponse.loading()
            : ApiResponse.loadingMore(),
      );
      final response = await MyHttpClient.instance.get(
        ApiEndpoints.getStores,
        params: params,
      );

      if (!ref.mounted) return;

      if (response != null) {
        List temp = response['stores'] ?? [];
        final List<StoreDataModel> list = List.from(
          temp.map((e) => StoreDataModel.fromJson(e)),
        );
        state = state.copyWith(
          getStoresApiResponse: ApiResponse.completed(response),
          stores: skip == 0 && state.stores!.isEmpty
              ? list
              : [...state.stores!, ...list],
          storesSkip: list.length >= limit ? skip + limit : 0,
        );
      } else {
        state = state.copyWith(
          getStoresApiResponse: skip == 0
              ? ApiResponse.error()
              : ApiResponse.undertermined(),
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        getStoresApiResponse: skip == 0
            ? ApiResponse.error()
            : ApiResponse.undertermined(),
      );
    }
  }

  FutureOr<void> getNearbyStores({
    required int limit,
    required int skip,
  }) async {
    if (!ref.mounted) return;
    if (skip == 0 && state.nearbyStores!.isNotEmpty) {
      state = state.copyWith(nearbyStores: [], nearbyStoresSkip: 0);
    }
    Map<String, dynamic> params = {'limit': limit, 'skip': skip};

    try {
      state = state.copyWith(
        getNearbyStoresApiResponse: skip == 0
            ? ApiResponse.loading()
            : ApiResponse.loadingMore(),
      );
      final response = await MyHttpClient.instance.get(
        ApiEndpoints.getNearbyStores,
        params: params,
      );

      if (!ref.mounted) return;

      if (response != null) {
        List temp = response['stores'] ?? [];
        final List<StoreDataModel> list = List.from(
          temp.map((e) => StoreDataModel.fromJson(e)),
        );
        state = state.copyWith(
          getNearbyStoresApiResponse: ApiResponse.completed(response),
          nearbyStores: skip == 0 && state.nearbyStores!.isEmpty
              ? list
              : [...state.nearbyStores!, ...list],
          nearbyStoresSkip: list.length >= limit ? skip + limit : 0,
        );
      } else {
        state = state.copyWith(
          getNearbyStoresApiResponse: skip == 0
              ? ApiResponse.error()
              : ApiResponse.undertermined(),
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        getNearbyStoresApiResponse: skip == 0
            ? ApiResponse.error()
            : ApiResponse.undertermined(),
      );
    }
  }
}

final homeProvider = NotifierProvider<HomeProvider, HomeState>(
  HomeProvider.new,
);
