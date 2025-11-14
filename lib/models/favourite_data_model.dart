


import 'package:push_price_user/export_all.dart';


class FavouriteModel {
  final int favoriteId;
  final List<ProductSelectionDataModel> products;
  final num distanceValue;
  final String distanceUnit;
  final bool travelMode;
  final List<LocationDataModel> addresses;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FavouriteModel({
    required this.favoriteId,
    required this.products,
    required this.distanceValue,
    required this.distanceUnit,
    required this.travelMode,
    required this.addresses,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FavouriteModel.fromJson(Map<String, dynamic> json) {
    return FavouriteModel(
      favoriteId: json['favorite_id'] ?? 0,
      products: json['products'] != null
          ? (json['products'] as List).map((e) => ProductSelectionDataModel.fromJson(e)).toList()
          : [],
      distanceValue: json['distance_value'] ?? 0,
      distanceUnit: json['distance_unit'] ?? 'METERS',
      travelMode: json['travel_mode'] ?? true,
      addresses: json['addresses'] != null
          ? (json['addresses'] as List).map((e) => LocationDataModel.fromJson(e)).toList()
          : [],
      createdAt: DateTime.tryParse(json['created_at']) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'favorite_id': favoriteId,
      'products': products.map((e) => e.toJson()).toList(),
      'distance_value': distanceValue,
      'distance_unit': distanceUnit,
      'travel_mode': travelMode,
      'addresses': addresses.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  FavouriteModel copyWith({
    int? favoriteId,
    List<ProductSelectionDataModel>? products,
    num? distanceValue,
    String? distanceUnit,
    bool? travelMode,
    List<LocationDataModel>? addresses,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FavouriteModel(
      favoriteId: favoriteId ?? this.favoriteId,
      products: products ?? this.products,
      distanceValue: distanceValue ?? this.distanceValue,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      travelMode: travelMode ?? this.travelMode,
      addresses: addresses ?? this.addresses,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
