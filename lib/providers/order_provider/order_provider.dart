import 'dart:async';

import 'package:flutter_stripe/flutter_stripe.dart';
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
      payNowApiResponse: ApiResponse.undertermined(),
      calculatePricingApiResponse: ApiResponse.undertermined(),
      validateVoucherApiResponse: ApiResponse.undertermined(),
    );
  }

  FutureOr<void> getOrders({required String type}) async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(getOrdersApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.get(
        ApiEndpoints.orders,
        params: {'status_filter': type},
      );

      if (!ref.mounted) return;

      if (response != null &&
          !(response is Map && response.containsKey('detail'))) {
        List temp = response ?? [];
        final List<OrderModel> list = List.from(
          temp.map((e) => OrderModel.fromJson(e)),
        );
        state = state.copyWith(
          getOrdersApiResponse: ApiResponse.completed(response),
          orders: list,
        );
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail'))
              ? response['detail'] as String
              : AppRouter.navKey.currentContext!.tr("failed_to_get_orders"),
        );
        state = state.copyWith(getOrdersApiResponse: ApiResponse.error());
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(getOrdersApiResponse: ApiResponse.error());
    }
  }

  FutureOr<void> placeOrder(Map<String, dynamic> orderData, int? count) async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(placeOrderApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.post(
        ApiEndpoints.orders,
        orderData,
      );

      if (!ref.mounted) return;

      if (response != null &&
          !(response is Map && response.containsKey('detail'))) {
        final OrderModel order = OrderModel.fromJson(response);

        ref.read(homeProvider.notifier).clearCartList();
        state = state.copyWith(
          placeOrderApiResponse: ApiResponse.completed(response),
          placedOrder: order,
          validateVoucherApiResponse: ApiResponse.undertermined(),
        );

        AppRouter.pushReplacement(
          OrderSuccessModifiedView(
            count: count,
            message: "Your Order Has Been Placed Successfully!",
          ),
        );
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail'))
              ? response['detail'] as String
              : AppRouter.navKey.currentContext!.tr("failed_to_place_order"),
        );
        state = state.copyWith(placeOrderApiResponse: ApiResponse.error());
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(placeOrderApiResponse: ApiResponse.error());
    }
  }

  FutureOr<void> getOrderDetail({required int orderId}) async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(getOrderDetailApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.get(
        ApiEndpoints.getOrderDetail(orderId),
      );

      if (!ref.mounted) return;

      if (response != null &&
          !(response is Map && response.containsKey('detail'))) {
        final OrderModel order = OrderModel.fromJson(response);
        state = state.copyWith(
          getOrderDetailApiResponse: ApiResponse.completed(response),
          orderDetail: order,
        );
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail'))
              ? response['detail'] as String
              : AppRouter.navKey.currentContext!.tr(
                  "failed_to_get_order_detail",
                ),
        );
        state = state.copyWith(getOrderDetailApiResponse: ApiResponse.error());
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(getOrderDetailApiResponse: ApiResponse.error());
    }
  }

  FutureOr<void> cancelOrder({required int orderId}) async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(cancelOrderApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.post(
        ApiEndpoints.cancelOrder(orderId),
        null,
      );

      if (!ref.mounted) return;

      if (response != null &&
          !(response is Map && response.containsKey('detail'))) {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: "Order successfully cancelled!",
        );
        AppRouter.customback(times: 2);
        state = state.copyWith(
          cancelOrderApiResponse: ApiResponse.completed(response),
        );
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail'))
              ? response['detail'] as String
              : AppRouter.navKey.currentContext!.tr("failed_to_cancel_order"),
        );
        state = state.copyWith(cancelOrderApiResponse: ApiResponse.error());
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(cancelOrderApiResponse: ApiResponse.error());
    }
  }

  FutureOr<void> validateVoucher({
    required String voucherCode,
    required num totalAmount,
  }) async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(validateVoucherApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.post(
        ApiEndpoints.validateVoucher,
        {"code": voucherCode, "order_total": totalAmount},
      );

      if (!ref.mounted) return;

      if (response != null &&
          !(response is Map && response.containsKey('detail'))) {
        final VoucherModel voucher = VoucherModel.fromJson(response);
        state = state.copyWith(
          validateVoucherApiResponse: ApiResponse.completed(voucher),
        );
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail'))
              ? response['detail'] as String
              : AppRouter.navKey.currentContext!.tr(
                  "failed_to_validate_voucher",
                ),
        );
        state = state.copyWith(validateVoucherApiResponse: ApiResponse.error());
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(validateVoucherApiResponse: ApiResponse.error());
    }
  }

  FutureOr<void> updateOrder({
    required int orderId,
    required List<Map<String, dynamic>> items,
  }) async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(updateOrderApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.put(
        ApiEndpoints.updateOrder(orderId),
        {"items": items},
      );

      if (!ref.mounted) return;

      if (response != null &&
          !(response is Map && response.containsKey('detail'))) {
        state = state.copyWith(
          updateOrderApiResponse: ApiResponse.completed(response),
        );
        AppRouter.pushReplacement(
          OrderSuccessModifiedView(
            message: "Your Order Has Been Modified Successfully!",
          ),
        );
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail'))
              ? response['detail'] as String
              : AppRouter.navKey.currentContext!.tr("failed_to_update_order"),
        );
        state = state.copyWith(updateOrderApiResponse: ApiResponse.error());
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(updateOrderApiResponse: ApiResponse.error());
    }
  }

  FutureOr<void> payNow({
    required int orderId,
    required String chainCode,
  }) async {
    if (!ref.mounted) return;
    String paymentIntentId = state.orderDetail?.paymentIntentId ?? "";

    try {
      state = state.copyWith(payNowApiResponse: ApiResponse.loading());
      if (paymentIntentId != "") {
        confirmPayment(orderId, paymentIntentId);
        return;
      }

      // Create payment intent
      final intentResponse = await MyHttpClient.instance.post(
        ApiEndpoints.paymentIntent(orderId),
        {"chain_code": chainCode},
      );

      if (!ref.mounted) return;

      if (intentResponse != null &&
          !(intentResponse is Map && intentResponse.containsKey('detail'))) {
        String clientSecret = intentResponse['client_secret'];
        paymentIntentId = intentResponse['payment_intent_id'];

        // Make payment with Stripe
        await makePayment(clientSecret);
        // state = state.copyWith(payNowApiResponse: ApiResponse.completed(intentResponse));

        confirmPayment(orderId, paymentIntentId);
      } else {
        state = state.copyWith(payNowApiResponse: ApiResponse.error());
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message:
              (intentResponse is Map && intentResponse.containsKey('detail'))
              ? intentResponse['detail'] as String
              : AppRouter.navKey.currentContext!.tr(
                  "payment_intent_creation_failed",
                ),
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(payNowApiResponse: ApiResponse.error());
      Helper.showMessage(
        AppRouter.navKey.currentContext!,
        message: AppRouter.navKey.currentContext!.tr('unable_to_process_payment'),
      );
    }
  }

  Future<void> confirmPayment(int orderId, String paymentIntentId) async {
    try {
      if (!ref.mounted) return;
      // Confirm payment
      final confirmResponse = await MyHttpClient.instance.post(
        ApiEndpoints.confirmPayment(orderId),
        {"payment_intent_id": paymentIntentId},
      );
      if (confirmResponse != null &&
          !(confirmResponse is Map && confirmResponse.containsKey('detail'))) {
        state = state.copyWith(
          payNowApiResponse: ApiResponse.completed(confirmResponse),
        );
        AppRouter.push(OrderDetailView(orderId: orderId, afterPayment: true));
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: "Payment successful!",
        );
      } else {
        state = state.copyWith(payNowApiResponse: ApiResponse.error());
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message:
              (confirmResponse is Map && confirmResponse.containsKey('detail'))
              ? confirmResponse['detail'] as String
              : AppRouter.navKey.currentContext!.tr(
                  "payment_confirmation_failed",
                ),
        );
      }
    } catch (e) {
      state = state.copyWith(payNowApiResponse: ApiResponse.error());
    }
  }

  Future<void> makePayment(String clientSecret) async {
    try {
      // Optionally collect card details
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Your App Name',
        ),
      );

      // Present the payment sheet
      await Stripe.instance.presentPaymentSheet();

    } catch (e) {
      rethrow; // Rethrow to handle in payNow
    }
  }

  FutureOr<void> calculatePricing({
    required List<Map<String, dynamic>> items,
    String? voucherCode,
  }) async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(calculatePricingApiResponse: ApiResponse.loading());
      final requestBody = {
        "items": items,
        if (voucherCode != null) "voucher_code": voucherCode,
      };
      final response = await MyHttpClient.instance.post(
        ApiEndpoints.calculatePricing,
        requestBody,
      );

      if (!ref.mounted) return;

      if (response != null &&
          !(response is Map && response.containsKey('detail'))) {
        state = state.copyWith(
          calculatePricingApiResponse: ApiResponse.completed(response),
        );
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail'))
              ? response['detail'] as String
              : AppRouter.navKey.currentContext!.tr("failed_to_calculate_pricing"),
        );
        state = state.copyWith(calculatePricingApiResponse: ApiResponse.error());
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(calculatePricingApiResponse: ApiResponse.error());
    }
  }

  void voucherApiUnset() {
    state = state.copyWith(
      validateVoucherApiResponse: ApiResponse.undertermined(),
    );
  }
}

final orderProvider = NotifierProvider.autoDispose<OrderProvider, OrderState>(
  OrderProvider.new,
);
