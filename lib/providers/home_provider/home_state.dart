import '../../data/network/api_response.dart';
import '../../export_all.dart';

class HomeState {
  final ApiResponse getCategoriesApiResponse;
  final List<CategoryDataModel>? categories;
  final int? chainId;
  final ApiResponse getStoresApiResponse;
  final List<StoreDataModel>? stores;
  final int storesSkip;
  final ApiResponse getStoreProductsApiResponse;
  final List<ProductPurchasingDataModel>? products;
  final int productsSkip;
  final ApiResponse getPromotionalProductsApiResponse;
  final List<ProductPurchasingDataModel>? promotionalProducts;
  final int promotionalProductsSkip;
  final ApiResponse getProductDetailApiResponse;
  final ProductDataModel? productDetail;
  final ApiResponse getNearbyStoresApiResponse;
  final List<StoreDataModel>? nearbyStores;
  final int nearbyStoresSkip;
  final List<ProductPurchasingDataModel> cartList;

  HomeState({
    required this.getCategoriesApiResponse,
    this.categories,
    this.chainId,
    required this.getStoresApiResponse,
    this.stores,
    this.storesSkip = 0,
    required this.getStoreProductsApiResponse,
    this.products,
    this.productsSkip = 0,
    required this.getPromotionalProductsApiResponse,
    this.promotionalProducts,
    this.promotionalProductsSkip = 0,
    required this.getProductDetailApiResponse,
    this.productDetail,
    required this.getNearbyStoresApiResponse,
    this.nearbyStores,
    this.nearbyStoresSkip = 0,
    this.cartList = const [],
  });

  HomeState copyWith({
    ApiResponse? getCategoriesApiResponse,
    List<CategoryDataModel>? categories,
    int? chainId,
    ApiResponse? getStoresApiResponse,
    List<StoreDataModel>? stores,
    int? storesSkip,
    ApiResponse? getStoreProductsApiResponse,
    List<ProductPurchasingDataModel>? products,
    int? productsSkip,
    ApiResponse? getPromotionalProductsApiResponse,
    List<ProductPurchasingDataModel>? promotionalProducts,
    int? promotionalProductsSkip,
    ApiResponse? getProductDetailApiResponse,
    ProductDataModel? productDetail,
    ApiResponse? getNearbyStoresApiResponse,
    List<StoreDataModel>? nearbyStores,
    int? nearbyStoresSkip,
    List<ProductPurchasingDataModel>? cartList,
  }) => HomeState(
    getCategoriesApiResponse: getCategoriesApiResponse ?? this.getCategoriesApiResponse,
    categories: categories ?? this.categories,
    chainId: chainId ?? this.chainId,
    getStoresApiResponse: getStoresApiResponse ?? this.getStoresApiResponse,
    stores: stores ?? this.stores,
    storesSkip: storesSkip ?? this.storesSkip,
    getStoreProductsApiResponse: getStoreProductsApiResponse ?? this.getStoreProductsApiResponse,
    products: products ?? this.products,
    productsSkip: productsSkip ?? this.productsSkip,
    getPromotionalProductsApiResponse: getPromotionalProductsApiResponse ?? this.getPromotionalProductsApiResponse,
    promotionalProducts: promotionalProducts ?? this.promotionalProducts,
    promotionalProductsSkip: promotionalProductsSkip ?? this.promotionalProductsSkip,
    getProductDetailApiResponse: getProductDetailApiResponse ?? this.getProductDetailApiResponse,
    productDetail: productDetail ?? this.productDetail,
    getNearbyStoresApiResponse: getNearbyStoresApiResponse ?? this.getNearbyStoresApiResponse,
    nearbyStores: nearbyStores ?? this.nearbyStores,
    nearbyStoresSkip: nearbyStoresSkip ?? this.nearbyStoresSkip,
    cartList: cartList ?? this.cartList,
  );
}
