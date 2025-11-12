import 'dart:async';

import 'package:push_price_user/export_all.dart';

import '../../../data/network/api_response.dart';
import 'order_state.dart';

class OrderProvider extends Notifier<OrderState> {
  @override
  OrderState build() {
    return OrderState(
      getOrdersApiResponse: ApiResponse.undertermined(),
      orders: [],
      placeOrderApiResponse: ApiResponse.undertermined(),
      placedOrder: null,
      getOrderDetailApiResponse: ApiResponse.undertermined(),
      orderDetail: null,
      cancelOrderApiResponse: ApiResponse.undertermined(),
      updateOrderApiResponse: ApiResponse.undertermined(),
      validateVoucherApiResponse: ApiResponse.undertermined(),

    );
  }


  FutureOr<void> getOrders({String? type}) async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(getOrdersApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.get(ApiEndpoints.orders);

      if (!ref.mounted) return;

      if (response != null) {
        List temp = response ?? [];
        final List<OrderModel> list = List.from(
          temp.map((e) => OrderModel.fromJson(e)),
        );
        state = state.copyWith(
          getOrdersApiResponse: ApiResponse.completed(response),
          orders: list,
        );
      } else {
        state = state.copyWith(
          getOrdersApiResponse: ApiResponse.error(),
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        getOrdersApiResponse: ApiResponse.error(),
      );
    }
  }

  FutureOr<void> placeOrder(Map<String, dynamic> orderData, int? count) async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(placeOrderApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.post(ApiEndpoints.orders, orderData);

      if (!ref.mounted) return;

      if (response != null) {
        final OrderModel order = OrderModel.fromJson(response);
       
        ref.read(homeProvider.notifier).clearCartList();
        state = state.copyWith(
          placeOrderApiResponse: ApiResponse.completed(response),
          placedOrder: order,
          validateVoucherApiResponse: ApiResponse.undertermined()
        );
        
        AppRouter.pushReplacement(
          OrderSuccessModifiedView(
            count:count,
            message: "Your Order Has Been Placed Successfully!",
          ),
        );
      } else {
        state = state.copyWith(
          placeOrderApiResponse: ApiResponse.error(),
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        placeOrderApiResponse: ApiResponse.error(),
      );
    }
  }

  FutureOr<void> getOrderDetail({required int orderId}) async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(getOrderDetailApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.get(ApiEndpoints.getOrderDetail(orderId));

      if (!ref.mounted) return;

      if (response != null) {
        final OrderModel order = OrderModel.fromJson(response);
        state = state.copyWith(
          getOrderDetailApiResponse: ApiResponse.completed(response),
          orderDetail: order,
        );
      } else {
        state = state.copyWith(
          getOrderDetailApiResponse: ApiResponse.error(),
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        getOrderDetailApiResponse: ApiResponse.error(),
      );
    }
  }

  FutureOr<void> cancelOrder({required int orderId}) async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(cancelOrderApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.post(ApiEndpoints.cancelOrder(orderId), null);

      if (!ref.mounted) return;

      if (response != null) {
        AppRouter.customback(times: 2);
        state = state.copyWith(
          cancelOrderApiResponse: ApiResponse.completed(response),
        );
      } else {
        state = state.copyWith(
          cancelOrderApiResponse: ApiResponse.error(),
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        cancelOrderApiResponse: ApiResponse.error(),
      );
    }
  }

  FutureOr<void> validateVoucher({required String voucherCode, required num totalAmount}) async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(validateVoucherApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.post(ApiEndpoints.validateVoucher, {"code": voucherCode, "order_total": totalAmount});

      if (!ref.mounted) return;

      if (response != null && !(response is Map && response.containsKey('detail'))) {
        final VoucherModel voucher = VoucherModel.fromJson(response);
        state = state.copyWith(
          validateVoucherApiResponse: ApiResponse.completed(voucher),
        );
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("failed_to_validate_voucher"),
        );
        state = state.copyWith(
          validateVoucherApiResponse: ApiResponse.error(),
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        validateVoucherApiResponse: ApiResponse.error(),
      );
    }
  }

  FutureOr<void> updateOrder({required int orderId, required List<Map<String, dynamic>> items}) async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(updateOrderApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.put(ApiEndpoints.updateOrder(orderId), {"items": items});

      if (!ref.mounted) return;

      if (response != null) {
        state = state.copyWith(
          updateOrderApiResponse: ApiResponse.completed(response),
        );
        // getOrderDetail(orderId: orderId);
        AppRouter.pushReplacement(OrderSuccessModifiedView(
          message: "Your Order Has Been Modified Successfully!",
        ));
        
      } else {
        state = state.copyWith(
          updateOrderApiResponse: ApiResponse.error(),
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        updateOrderApiResponse: ApiResponse.error(),
      );
    }
  }

  void voucherApiUnset(){
    state =state.copyWith(
      validateVoucherApiResponse: ApiResponse.undertermined()
    );
  }
}

final orderProvider = NotifierProvider.autoDispose<OrderProvider, OrderState>(
  OrderProvider.new,
);
