import '../../../data/network/api_response.dart';
import '../../../export_all.dart';
import '../../../models/favourite_data_model.dart';

class FavouriteState {
  final ApiResponse getProductsApiResponse;
  final List<ProductSelectionDataModel>? products;
  final ApiResponse getProductDetailApiResponse;
  final ProductDataModel? productDetail;
  final ApiResponse getProductByBarCodeApiResponse;
  final ProductDataModel? productByBarCode;
  final ApiResponse getFavouriteProductsApiResponse;
  final List<FavouriteModel>? favouriteProducts;
  final ApiResponse addNewFavouriteApiResponse;
  final ApiResponse updateFavouriteApiResponse;
  final ApiResponse deleteFavouriteApiResponse;

  FavouriteState({
    required this.getProductsApiResponse,
    this.products,
    required this.getProductDetailApiResponse,
    this.productDetail,
    required this.getProductByBarCodeApiResponse,
    this.productByBarCode,
    required this.getFavouriteProductsApiResponse,
    this.favouriteProducts,
    required this.addNewFavouriteApiResponse,
    required this.updateFavouriteApiResponse,
    required this.deleteFavouriteApiResponse,
  });

  factory FavouriteState.initial() {
    return FavouriteState(
      getProductsApiResponse: ApiResponse.undertermined(),
      products: [],
      getProductDetailApiResponse: ApiResponse.undertermined(),
      productDetail: null,
      getProductByBarCodeApiResponse: ApiResponse.undertermined(),
      productByBarCode: null,
      getFavouriteProductsApiResponse: ApiResponse.undertermined(),
      favouriteProducts: [],
      addNewFavouriteApiResponse: ApiResponse.undertermined(),
      updateFavouriteApiResponse: ApiResponse.undertermined(),
      deleteFavouriteApiResponse: ApiResponse.undertermined(),
    );
  }

  FavouriteState copyWith({
    ApiResponse? getProductsApiResponse,
    List<ProductSelectionDataModel>? products,
    ApiResponse? getProductDetailApiResponse,
    ProductDataModel? productDetail,
    ApiResponse? getProductByBarCodeApiResponse,
    ProductDataModel? productByBarCode,
    ApiResponse? getFavouriteProductsApiResponse,
    List<FavouriteModel>? favouriteProducts,
    ApiResponse? addNewFavouriteApiResponse,
    ApiResponse? updateFavouriteApiResponse,
    ApiResponse? deleteFavouriteApiResponse,
  }) => FavouriteState(
    getProductsApiResponse: getProductsApiResponse ?? this.getProductsApiResponse,
    products: products ?? this.products,
    getProductDetailApiResponse: getProductDetailApiResponse ?? this.getProductDetailApiResponse,
    productDetail: productDetail ?? this.productDetail,
    getProductByBarCodeApiResponse: getProductByBarCodeApiResponse ?? this.getProductByBarCodeApiResponse,
    productByBarCode: productByBarCode ?? this.productByBarCode,
    getFavouriteProductsApiResponse: getFavouriteProductsApiResponse ?? this.getFavouriteProductsApiResponse,
    favouriteProducts: favouriteProducts ?? this.favouriteProducts,
    addNewFavouriteApiResponse: addNewFavouriteApiResponse ?? this.addNewFavouriteApiResponse,
    updateFavouriteApiResponse: updateFavouriteApiResponse ?? this.updateFavouriteApiResponse,
    deleteFavouriteApiResponse: deleteFavouriteApiResponse ?? this.deleteFavouriteApiResponse,
  );
}
