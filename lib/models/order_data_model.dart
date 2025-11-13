

import 'package:push_price_user/export_all.dart';

class OrderModel {
  final int orderId;
  final int userId;
  final int storeId;
  final int addressId;
  final String status;
  final num totalAmount;
  final num discountAmount;
  final num finalAmount;
  final String? voucherCode;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItem> items;
  final Address shippingAddress;
  final String? paymentIntentId;
  

  const OrderModel({
    required this.orderId,
    required this.userId,
    required this.storeId,
    required this.addressId,
    required this.status,
    required this.totalAmount,
    required this.discountAmount,
    required this.finalAmount,
    this.voucherCode,
    this.notes,
    this.paymentIntentId,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
    required this.shippingAddress,

  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      storeId: json['store_id'] ?? 0,
      addressId: json['address_id'] ?? 0,
      status: json['status'] ?? '',
      totalAmount: json['total_amount'] ?? 0,
      discountAmount: json['discount_amount'] ?? 0,
      finalAmount: json['final_amount'] ?? 0,
      voucherCode: json['voucher_code'],
      notes: json['notes'],
      createdAt: DateTime.tryParse(json['created_at']) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']) ?? DateTime.now(),
      items: json['items'] != null
          ? (json['items'] as List).map((e) => OrderItem.fromJson(e)).toList()
          : [],
      shippingAddress: json['shipping_address'] != null
          ? Address.fromJson(json['shipping_address'])
          : Address(),
      paymentIntentId: json['payment_intent_id'] ?? ""
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'user_id': userId,
      'store_id': storeId,
      'address_id': addressId,
      'status': status,
      'total_amount': totalAmount,
      'discount_amount': discountAmount,
      'final_amount': finalAmount,
      'voucher_code': voucherCode,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'items': items.map((e) => e.toJson()).toList(),
      'shipping_address': shippingAddress.toJson(),
    };
  }
}

class OrderItem {
  final int orderItemId;
  final int listingId;
  final int productId;
  final String productName;
  final int quantity;
  final num unitPrice;
  final num totalPrice;
  final ListingModel listingData;

  const OrderItem({
    required this.orderItemId,
    required this.listingId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.listingData
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      orderItemId: json['order_item_id'] ?? 0,
      listingId: json['listing_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      productName: json['product_name'] ?? '',
      quantity: json['quantity'] ?? 0,
      unitPrice: json['unit_price'] ?? 0,
      totalPrice: json['total_price'] ?? 0,
      listingData: ListingModel.fromJson(json['listing'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_item_id': orderItemId,
      'listing_id': listingId,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'listing' : listingData.toJson()
    };
  }
}

class Address {
  final int addressId;
  final String label;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final num latitude;
  final num longitude;

  const Address({
    this.addressId = 0,
    this.label = '',
    this.addressLine1 = '',
    this.addressLine2,
    this.city = '',
    this.state = '',
    this.postalCode = '',
    this.country = '',
    this.latitude = 0,
    this.longitude = 0,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressId: json['address_id'] ?? 0,
      label: json['label'] ?? '',
      addressLine1: json['address_line1'] ?? '',
      addressLine2: json['address_line2'],
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postal_code'] ?? '',
      country: json['country'] ?? '',
      latitude: json['latitude'] ?? 0,
      longitude: json['longitude'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address_id': addressId,
      'label': label,
      'address_line1': addressLine1,
      'address_line2': addressLine2,
      'city': city,
      'state': state,
      'postal_code': postalCode,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
