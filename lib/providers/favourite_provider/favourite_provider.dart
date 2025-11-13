import 'dart:async';

import 'package:push_price_user/export_all.dart';

import '../../../data/network/api_response.dart';
import 'favourite_state.dart';

class FavouriteProvider extends Notifier<FavouriteState> {
  @override
  FavouriteState build() {
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

  FutureOr<void> getProducts({required int skip, required int limit, int? categoryId, String? search, int? storeId}) async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(getProductsApiResponse: ApiResponse.loading());
      Map<String, dynamic> params = {
        'skip': skip,
        'limit': limit,
      };
      if (categoryId != null) params['category_id'] = categoryId;
      if (search != null && search.isNotEmpty) params['search'] = search;
      if (storeId != null) params['store_id'] = storeId;

      final response = await MyHttpClient.instance.get(ApiEndpoints.products, params: params);

      if (!ref.mounted) return;

      if (response != null && !(response is Map && response.containsKey('detail'))) {
        List temp = response['products'] ?? [];
        final List<ProductSelectionDataModel> list = List.from(
          temp.map((e) => ProductSelectionDataModel.fromJson(e)),
        );
        state = state.copyWith(
          getProductsApiResponse: ApiResponse.completed(response),
          products: list,
        );
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("failed_to_get_products"),
        );
        state = state.copyWith(
          getProductsApiResponse: ApiResponse.error(),
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        getProductsApiResponse: ApiResponse.error(),
      );
    }
  }

  FutureOr<void> getProductDetail({required int productId}) async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(getProductDetailApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.get(ApiEndpoints.getFavouriteProductDetail(productId));

      if (!ref.mounted) return;

      if (response != null && !(response is Map && response.containsKey('detail'))) {
        final ProductDataModel product = ProductDataModel.fromJson(response);
        state = state.copyWith(
          getProductDetailApiResponse: ApiResponse.completed(response),
          productDetail: product,
        );
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("failed_to_get_product_detail"),
        );
        state = state.copyWith(
          getProductDetailApiResponse: ApiResponse.error(),
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        getProductDetailApiResponse: ApiResponse.error(),
      );
    }
  }

  FutureOr<void> getProductByBarCode({required String barcode, int? storeId}) async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(getProductByBarCodeApiResponse: ApiResponse.loading());
      Map<String, dynamic> params = {};
      if (storeId != null) params['store_id'] = storeId;

      final response = await MyHttpClient.instance.get(ApiEndpoints.getProductByBarCode(barcode), params: params);

      if (!ref.mounted) return;

      if (response != null && !(response is Map && response.containsKey('detail'))) {
        final ProductDataModel product = ProductDataModel.fromJson(response);
        state = state.copyWith(
          getProductByBarCodeApiResponse: ApiResponse.completed(response),
          productByBarCode: product,
        );
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("failed_to_get_product_by_barcode"),
        );
        state = state.copyWith(
          getProductByBarCodeApiResponse: ApiResponse.error(),
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        getProductByBarCodeApiResponse: ApiResponse.error(),
      );
    }
  }

  FutureOr<void> getFavouriteProducts({String?search}) async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(getFavouriteProductsApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.get(ApiEndpoints.favourites);

      if (!ref.mounted) return;

      if (response != null && !(response is Map && response.containsKey('detail'))) {
        List temp = response ?? [];
        final List<ProductDataModel> list = List.from(
          temp.map((e) => ProductDataModel.fromJson(e)),
        );
        state = state.copyWith(
          getFavouriteProductsApiResponse: ApiResponse.completed(response),
          favouriteProducts: list,
        );
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("failed_to_get_favourite_products"),
        );
        state = state.copyWith(
          getFavouriteProductsApiResponse: ApiResponse.error(),
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        getFavouriteProductsApiResponse: ApiResponse.error(),
      );
    }
  }

  FutureOr<void> addNewFavourite(Map<String, dynamic> favouriteData) async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(addNewFavouriteApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.post(ApiEndpoints.favourites, favouriteData);

      if (!ref.mounted) return;

      if (response != null && !(response is Map && response.containsKey('detail'))) {
        AppRouter.customback(times: 2);
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: "Favourite added successfully!",
        );
        state = state.copyWith(
          addNewFavouriteApiResponse: ApiResponse.completed(response),
        );
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("failed_to_add_favourite"),
        );
        state = state.copyWith(
          addNewFavouriteApiResponse: ApiResponse.error(),
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        addNewFavouriteApiResponse: ApiResponse.error(),
      );
    }
  }

  FutureOr<void> updateFavourite({required int favouriteId, required Map<String, dynamic> favouriteData}) async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(updateFavouriteApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.put(ApiEndpoints.updateFavourite(favouriteId), favouriteData);

      if (!ref.mounted) return;

      if (response != null && !(response is Map && response.containsKey('detail'))) {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: "Favourite updated successfully!",
        );
        state = state.copyWith(
          updateFavouriteApiResponse: ApiResponse.completed(response),
        );
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("failed_to_update_favourite"),
        );
        state = state.copyWith(
          updateFavouriteApiResponse: ApiResponse.error(),
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        updateFavouriteApiResponse: ApiResponse.error(),
      );
    }
  }

  FutureOr<void> deleteFavourite({required int favouriteId}) async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(deleteFavouriteApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.delete(ApiEndpoints.deleteFavourite(favouriteId), null);

      if (!ref.mounted) return;

      if (response != null && !(response is Map && response.containsKey('detail'))) {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: "Favourite deleted successfully!",
        );
        state = state.copyWith(
          deleteFavouriteApiResponse: ApiResponse.completed(response),
        );
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("failed_to_delete_favourite"),
        );
        state = state.copyWith(
          deleteFavouriteApiResponse: ApiResponse.error(),
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        deleteFavouriteApiResponse: ApiResponse.error(),
      );
    }
  }

  void selectProduct(int index){
    List<ProductSelectionDataModel> updateProducts = state.products?.map((e) => e).toList() ?? [];
    if(updateProducts.isNotEmpty && index < updateProducts.length){
      ProductSelectionDataModel product = updateProducts[index];
      updateProducts[index] = product.copyWith(isSelect: !product.isSelect);
      state = state.copyWith(products: updateProducts);
    }
  }

  void clearProducts(){
    state = state.copyWith(products: []);
  }
}

final favouriteProvider = NotifierProvider.autoDispose<FavouriteProvider, FavouriteState>(
  FavouriteProvider.new,
);
