import '../../data/network/api_response.dart';
import '../../export_all.dart';

class HomeState {
  final ApiResponse getCategoriesApiResponse;
  final List<CategoryDataModel>? categories;
  final int? chainId;
  final ApiResponse getStoresApiResponse;
  final List<StoreDataModel>? stores;
  final int storesSkip;
  final ApiResponse getNearbyStoresApiResponse;
  final List<StoreDataModel>? nearbyStores;
  final int nearbyStoresSkip;

  HomeState({
    required this.getCategoriesApiResponse,
    this.categories,
    this.chainId,
    required this.getStoresApiResponse,
    this.stores,
    this.storesSkip = 0,
    required this.getNearbyStoresApiResponse,
    this.nearbyStores,
    this.nearbyStoresSkip = 0,
  });

  HomeState copyWith({
    ApiResponse? getCategoriesApiResponse,
    List<CategoryDataModel>? categories,
    int? chainId,
    ApiResponse? getStoresApiResponse,
    List<StoreDataModel>? stores,
    int? storesSkip,
    ApiResponse? getNearbyStoresApiResponse,
    List<StoreDataModel>? nearbyStores,
    int? nearbyStoresSkip,
  }) => HomeState(
    getCategoriesApiResponse: getCategoriesApiResponse ?? this.getCategoriesApiResponse,
    categories: categories ?? this.categories,
    chainId: chainId ?? this.chainId,
    getStoresApiResponse: getStoresApiResponse ?? this.getStoresApiResponse,
    stores: stores ?? this.stores,
    storesSkip: storesSkip ?? this.storesSkip,
    getNearbyStoresApiResponse: getNearbyStoresApiResponse ?? this.getNearbyStoresApiResponse,
    nearbyStores: nearbyStores ?? this.nearbyStores,
    nearbyStoresSkip: nearbyStoresSkip ?? this.nearbyStoresSkip,
  );
}
