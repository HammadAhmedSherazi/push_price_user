import '../../data/network/api_response.dart';
import '../../export_all.dart';

class HomeState {
  final ApiResponse getCategoriesApiResponse;
  final List<CategoryDataModel>? categories;
  final int? chainId;
  final ApiResponse getStoresApiResponse;
  final List<StoreDataModel>? stores;
  final int storesSkip;

  HomeState({
    required this.getCategoriesApiResponse,
    this.categories,
    this.chainId,
    required this.getStoresApiResponse,
    this.stores,
    this.storesSkip = 0,
  });

  HomeState copyWith({
    ApiResponse? getCategoriesApiResponse,
    List<CategoryDataModel>? categories,
    int? chainId,
    ApiResponse? getStoresApiResponse,
    List<StoreDataModel>? stores,
    int? storesSkip,
  }) => HomeState(
    getCategoriesApiResponse: getCategoriesApiResponse ?? this.getCategoriesApiResponse,
    categories: categories ?? this.categories,
    chainId: chainId ?? this.chainId,
    getStoresApiResponse: getStoresApiResponse ?? this.getStoresApiResponse,
    stores: stores ?? this.stores,
    storesSkip: storesSkip ?? this.storesSkip,
  );
}
