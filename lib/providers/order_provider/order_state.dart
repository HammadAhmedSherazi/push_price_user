import '../../../data/network/api_response.dart';
import '../../../export_all.dart';

class OrderState {
  final ApiResponse getOrdersApiResponse;
  final List<OrderModel>? orders;
  final ApiResponse placeOrderApiResponse;
  final OrderModel? placedOrder;
  final ApiResponse getOrderDetailApiResponse;
  final OrderModel? orderDetail;
  final ApiResponse cancelOrderApiResponse;
  final ApiResponse updateOrderApiResponse;
  final ApiResponse payNowApiResponse;
  final ApiResponse<VoucherModel?> validateVoucherApiResponse;


  OrderState({
    required this.getOrdersApiResponse,
    this.orders,
    required this.placeOrderApiResponse,
    this.placedOrder,
    required this.getOrderDetailApiResponse,
    this.orderDetail,
    required this.cancelOrderApiResponse,
    required this.updateOrderApiResponse,
    required this.payNowApiResponse,
    required this.validateVoucherApiResponse,

  });

  OrderState copyWith({
    ApiResponse? getOrdersApiResponse,
    List<OrderModel>? orders,
    ApiResponse? placeOrderApiResponse,
    OrderModel? placedOrder,
    ApiResponse? getOrderDetailApiResponse,
    OrderModel? orderDetail,
    ApiResponse? cancelOrderApiResponse,
    ApiResponse? updateOrderApiResponse,
    ApiResponse? payNowApiResponse,
    ApiResponse<VoucherModel?>? validateVoucherApiResponse,

  }) => OrderState(
    getOrdersApiResponse: getOrdersApiResponse ?? this.getOrdersApiResponse,
    orders: orders ?? this.orders,
    placeOrderApiResponse: placeOrderApiResponse ?? this.placeOrderApiResponse,
    placedOrder: placedOrder ?? this.placedOrder,
    getOrderDetailApiResponse: getOrderDetailApiResponse ?? this.getOrderDetailApiResponse,
    orderDetail: orderDetail ?? this.orderDetail,
    cancelOrderApiResponse: cancelOrderApiResponse ?? this.cancelOrderApiResponse,
    updateOrderApiResponse: updateOrderApiResponse ?? this.updateOrderApiResponse,
    payNowApiResponse: payNowApiResponse ?? this.payNowApiResponse,
    validateVoucherApiResponse: validateVoucherApiResponse ?? this.validateVoucherApiResponse,

  );
}
