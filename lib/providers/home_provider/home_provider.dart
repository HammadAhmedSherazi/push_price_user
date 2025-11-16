import 'dart:async';

import 'package:push_price_user/export_all.dart';

import '../../data/network/api_response.dart';
import 'home_state.dart';



class HomeProvider extends Notifier<HomeState> {
  @override
  HomeState build() {
    final cartList = SharedPreferenceManager.sharedInstance.getCartList();
    return HomeState(
      getCategoriesApiResponse: ApiResponse.undertermined(),
      categories: [],
      chainId: null,
      getStoresApiResponse: ApiResponse.undertermined(),
      stores: [],
      storesSkip: 0,
      getStoreProductsApiResponse: ApiResponse.undertermined(),
      products: [],
      productsSkip: 0,
      getPromotionalProductsApiResponse: ApiResponse.undertermined(),
      promotionalProducts: [],
      promotionalProductsSkip: 0,
      getProductDetailApiResponse: ApiResponse.undertermined(),
      productDetail: null,
      getNearbyStoresApiResponse: ApiResponse.undertermined(),
      nearbyStores: [],
      nearbyStoresSkip: 0,
      getCategoryStoresApiResponse: ApiResponse.undertermined(),
      categoryStores: [],
      categoryStoresSkip: 0,
      cartList: cartList,
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

      if (response != null && !(response is Map && response.containsKey('detail'))) {
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
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("failed_to_get_categories"),
        );
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

      if (response != null && !(response is Map && response.containsKey('detail'))) {
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
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("failed_to_get_stores"),
        );
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

  FutureOr<void> getStoreProducts({
    required int storeId,
    int? categoryId,
    String? search,
    String? type,
    required int skip,
    required int limit,
  }) async {
    if (!ref.mounted) return;
    if (skip == 0 && state.products!.isNotEmpty) {
      state = state.copyWith(products: [], productsSkip: 0);
    }
    Map<String, dynamic> params = {'skip': skip, 'limit': limit};
    if (categoryId != null) {
      params['category_id'] = categoryId;
    }
    if (search != null) {
      params['search'] = search;
    }
    if(type != null){
      params['listing_type_filter'] = type;
    }

    try {
      state = state.copyWith(
        getStoreProductsApiResponse: skip == 0
            ? ApiResponse.loading()
            : ApiResponse.loadingMore(),
      );
      final response = await MyHttpClient.instance.get(
        ApiEndpoints.getStoreProducts(storeId),
        params: params,
      );

      if (!ref.mounted) return;

      if (response != null && !(response is Map && response.containsKey('detail'))) {
        List temp = response['products'] ?? [];
        final List<ProductPurchasingDataModel> list = List.from(
          temp.map((e) {
            final cartIndex = state.cartList.indexWhere((cart) => cart.title == e['product_name']);
            final selectQty = cartIndex != -1 ? state.cartList[cartIndex].selectQuantity : 0;
            return ProductPurchasingDataModel.fromJson(e, quantity: selectQty, discount: e['current_discount_percent'] ?? 0);
          }),
        );
        state = state.copyWith(
          getStoreProductsApiResponse: ApiResponse.completed(response),
          products: skip == 0 && state.products!.isEmpty
              ? list
              : [...state.products!, ...list],
          productsSkip: list.length >= limit ? skip + limit : 0,
        );
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("failed_to_get_store_products"),
        );
        state = state.copyWith(
          getStoreProductsApiResponse: skip == 0
              ? ApiResponse.error()
              : ApiResponse.undertermined(),
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        getStoreProductsApiResponse: skip == 0
            ? ApiResponse.error()
            : ApiResponse.undertermined(),
      );
    }
  }

  FutureOr<void> getProductDetail({
    required int productId,
  }) async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(getProductDetailApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.get(
        ApiEndpoints.getProductDetail(productId),
      );

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

  void addQuantity(ProductPurchasingDataModel product, [int? index]) {
    List<ProductPurchasingDataModel> products = List.from(state.products ?? []);
    int productIndex = index ?? products.indexWhere((e) => e.listingId == product.listingId);
    if (productIndex != -1 && productIndex < products.length) {
      if (products[productIndex].selectQuantity < products[productIndex].quantity!) {
        final updatedProduct = products[productIndex].copyWith(selectQuantity: products[productIndex].selectQuantity + 1);
        products[productIndex] = updatedProduct;
        state = state.copyWith(products: products);
      } else {
        Helper.showMessage(AppRouter.navKey.currentState!.context, message: AppRouter.navKey.currentState!.context.tr('not_available_quantity_to_select'));
        return;
      }
    }
    else{
      List<ProductPurchasingDataModel> promotionalProducts = List.from(state.promotionalProducts ?? []);
      int productIndex = index ?? promotionalProducts.indexWhere((e) => e.listingId == product.listingId);
      if(productIndex != -1 && productIndex < promotionalProducts.length){
         List<ProductPurchasingDataModel> products = List.from(state.products ?? []);
         promotionalProducts.removeAt(productIndex);
      products.add(product.copyWith(selectQuantity: 1));
      state = state.copyWith(products: products, promotionalProducts: promotionalProducts);
      }
     
    }

    final existingIndex = state.cartList.indexWhere((e) => e.listingId == product.listingId);
    final updatedCartList = List<ProductPurchasingDataModel>.from(state.cartList);
    if (existingIndex != -1) {
      if (state.cartList[existingIndex].selectQuantity < state.cartList[existingIndex].quantity!) {
        final updatedProduct = state.cartList[existingIndex].copyWith(selectQuantity: state.cartList[existingIndex].selectQuantity + 1);
        updatedCartList[existingIndex] = updatedProduct;
      } else {
        Helper.showMessage(AppRouter.navKey.currentState!.context, message: AppRouter.navKey.currentState!.context.tr('not_available_quantity_to_select'));
      }
    } else {
      final updatedProduct = product.copyWith(selectQuantity: 1);
      updatedCartList.add(updatedProduct);
    }
    state = state.copyWith(cartList: updatedCartList);
    SharedPreferenceManager.sharedInstance.storeCartList(updatedCartList);
  }

  void removeQuantity(ProductPurchasingDataModel product) {
    // Update products list
    List<ProductPurchasingDataModel> products = List.from(state.products ?? []);
    int productIndex = products.indexWhere((e) => e.listingId == product.listingId);
    if (productIndex != -1) {
      if (products[productIndex].selectQuantity > 0) {
        final updatedProduct = products[productIndex].copyWith(selectQuantity: products[productIndex].selectQuantity - 1);
        products[productIndex] = updatedProduct;
        state = state.copyWith(products: products);
      }
    }

    // Update cart list
    final existingIndex = state.cartList.indexWhere((e) => e.listingId == product.listingId);
    if (existingIndex != -1) {
      final updatedCartList = List<ProductPurchasingDataModel>.from(state.cartList);
      if (state.cartList[existingIndex].selectQuantity > 1) {
        final updatedProduct = state.cartList[existingIndex].copyWith(selectQuantity: state.cartList[existingIndex].selectQuantity - 1);
        updatedCartList[existingIndex] = updatedProduct;
      } else {
        updatedCartList.removeAt(existingIndex);
      }
      state = state.copyWith(cartList: updatedCartList);
      SharedPreferenceManager.sharedInstance.storeCartList(updatedCartList);
    }
  }

  FutureOr<void> getPromotionalProducts({
    required int storeId,
    required int skip,
    required int limit,
  }) async {
    if (!ref.mounted) return;
    if (skip == 0 && state.promotionalProducts!.isNotEmpty) {
      state = state.copyWith(promotionalProducts: [], promotionalProductsSkip: 0);
    }
    Map<String, dynamic> params = {'skip': skip, 'limit': limit, 'listing_type_filter': 'PROMOTIONAL_PRODUCTS'};
    try {
      state = state.copyWith(
        getPromotionalProductsApiResponse: skip == 0
            ? ApiResponse.loading()
            : ApiResponse.loadingMore(),
      );
      final response = await MyHttpClient.instance.get(
        ApiEndpoints.getStoreProducts(storeId),
        params: params,
      );

      if (!ref.mounted) return;

      if (response != null && !(response is Map && response.containsKey('detail'))) {
        List temp = response['products'] ?? [];
        final List<ProductPurchasingDataModel> list = List.from(
          temp.map((e) {
            final cartIndex = state.cartList.indexWhere((cart) => cart.title == e['product_name']);
            final selectQty = cartIndex != -1 ? state.cartList[cartIndex].selectQuantity : 0;
            return ProductPurchasingDataModel.fromJson(e, quantity: selectQty, discount: e['current_discount_percent'] ?? 0);
          }),
        );
        state = state.copyWith(
          getPromotionalProductsApiResponse: ApiResponse.completed(response),
          promotionalProducts: skip == 0 && state.promotionalProducts!.isEmpty
              ? list
              : [...state.promotionalProducts!, ...list],
          promotionalProductsSkip: list.length >= limit ? skip + limit : 0,
        );
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("failed_to_get_promotional_products"),
        );
        state = state.copyWith(
          getPromotionalProductsApiResponse: skip == 0
              ? ApiResponse.error()
              : ApiResponse.undertermined(),
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        getPromotionalProductsApiResponse: skip == 0
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

      if (response != null && !(response is Map && response.containsKey('detail'))) {
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
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("failed_to_get_nearby_stores"),
        );
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
  FutureOr<void> getCategoryStores({
    required int categoryId,
    required int limit,
    required int skip,
  }) async {
    if (!ref.mounted) return;
    if (skip == 0 && state.categoryStores!.isNotEmpty) {
      state = state.copyWith(categoryStores: [], categoryStoresSkip: 0);
    }
    Map<String, dynamic> params = {'limit': limit, 'skip': skip};


    try {
      state = state.copyWith(
        getCategoryStoresApiResponse: skip == 0
            ? ApiResponse.loading()
            : ApiResponse.loadingMore(),
      );
      final response = await MyHttpClient.instance.get(
        ApiEndpoints.getCategoryStores(categoryId),
        params: params,
      );

      if (!ref.mounted) return;

      if (response != null && !(response is Map && response.containsKey('detail'))) {
        List temp = response['stores'] ?? [];
        final List<StoreDataModel> list = List.from(
          temp.map((e) => StoreDataModel.fromJson(e)),
        );
        state = state.copyWith(
          getCategoryStoresApiResponse: ApiResponse.completed(response),
          categoryStores: skip == 0 && state.categoryStores!.isEmpty
              ? list
              : [...state.categoryStores!, ...list],
          categoryStoresSkip: list.length >= limit ? skip + limit : 0,
        );
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("failed_to_get_category_stores"),
        );
        state = state.copyWith(
          getCategoryStoresApiResponse: skip == 0
              ? ApiResponse.error()
              : ApiResponse.undertermined(),
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        getCategoryStoresApiResponse: skip == 0
            ? ApiResponse.error()
            : ApiResponse.undertermined(),
      );
    }
  }

  void clearCartList()
  {
    SharedPreferenceManager.sharedInstance.clearCartList();
    state = state.copyWith(cartList: []);
  }
}

final homeProvider = NotifierProvider.autoDispose<HomeProvider, HomeState>(
  HomeProvider.new,
);
