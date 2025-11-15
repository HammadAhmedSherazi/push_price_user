import 'package:push_price_user/models/product_data_model.dart';
import 'package:push_price_user/models/store_data_model.dart';

class NotificationDataModel {
  final int notificationId;
  final String title;
  final String body;
  final String? imageUrl;
  final String? notificationType;
  final NotificationData? data;
  final int? productId;
  final int? storeId;
  final int? listingId;
  final double? distanceKm;
  final bool isRead;
  final bool? fcmSent;
  final String? sentAt;
  final String? readAt;
  final String createdAt;
  final ProductDataModel? product;
  final StoreDataModel? store;

  NotificationDataModel({
    required this.notificationId,
    required this.title,
    required this.body,
    this.imageUrl,
    this.notificationType,
    this.data,
    this.productId,
    this.storeId,
    this.listingId,
    this.distanceKm,
    required this.isRead,
    this.fcmSent,
    this.sentAt,
    this.readAt,
    required this.createdAt,
    this.product,
    this.store,
  });

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) {
    return NotificationDataModel(
      notificationId: json['notification_id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      imageUrl: json['image_url'],
      notificationType: json['notification_type'],
      data: json['data'] != null ? NotificationData.fromJson(json['data']) : null,
      productId: json['product_id'],
      storeId: json['store_id'],
      listingId: json['listing_id'],
      distanceKm: json['distance_km']?.toDouble(),
      isRead: json['is_read'] ?? false,
      fcmSent: json['fcm_sent'],
      sentAt: json['sent_at'],
      readAt: json['read_at'],
      createdAt: json['created_at'] ?? '',
      product: json['product'] != null ? ProductDataModel.fromJson(json['product']) : null,
      store: json['store'] != null ? StoreDataModel.fromJson(json['store']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notification_id': notificationId,
      'title': title,
      'body': body,
      'image_url': imageUrl,
      'notification_type': notificationType,
      'data': data?.toJson(),
      'product_id': productId,
      'store_id': storeId,
      'listing_id': listingId,
      'distance_km': distanceKm,
      'is_read': isRead,
      'fcm_sent': fcmSent,
      'sent_at': sentAt,
      'read_at': readAt,
      'created_at': createdAt,
      'product': product?.toJson(),
      'store': store?.toJson(),
    };
  }

  NotificationDataModel copyWith({
    int? notificationId,
    String? title,
    String? body,
    String? imageUrl,
    String? notificationType,
    NotificationData? data,
    int? productId,
    int? storeId,
    int? listingId,
    double? distanceKm,
    bool? isRead,
    bool? fcmSent,
    String? sentAt,
    String? readAt,
    String? createdAt,
    ProductDataModel? product,
    StoreDataModel? store,
  }) {
    return NotificationDataModel(
      notificationId: notificationId ?? this.notificationId,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      notificationType: notificationType ?? this.notificationType,
      data: data ?? this.data,
      productId: productId ?? this.productId,
      storeId: storeId ?? this.storeId,
      listingId: listingId ?? this.listingId,
      distanceKm: distanceKm ?? this.distanceKm,
      isRead: isRead ?? this.isRead,
      fcmSent: fcmSent ?? this.fcmSent,
      sentAt: sentAt ?? this.sentAt,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
      product: product ?? this.product,
      store: store ?? this.store,
    );
  }



  // Getter for id to maintain compatibility
  int get id => notificationId;

  // Getter for message to maintain compatibility
  String get message => body;
}

class NotificationData {
  final String? type;
  final String? productId;
  final String? storeId;
  final String? listingId;
  final String? addressId;
  final String? distance;

  NotificationData({
    this.type,
    this.productId,
    this.storeId,
    this.listingId,
    this.addressId,
    this.distance,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      type: json['type'],
      productId: json['product_id'],
      storeId: json['store_id'],
      listingId: json['listing_id'],
      addressId: json['address_id'],
      distance: json['distance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'product_id': productId,
      'store_id': storeId,
      'listing_id': listingId,
      'address_id': addressId,
      'distance': distance,
    };
  }
}
