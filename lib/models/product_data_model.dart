import 'package:push_price_user/export_all.dart';

class ProductDataModel {
  final String title;
  final String description;
  final String image;
  final num? price;
  final num? discountedPrice;
  final int? quantity;
  final int? id;
  final int ? chainId;
  final String ? type;
  final DateTime ? createdAt;
  final CategoryDataModel? category;
  final StoreDataModel ? store;
  final List<StoreDataModel>? stores;
  final DateTime? bestByDate;
  final DateTime? goLiveDate;
  final List<double>? weightedItemsPrices;
  final int? listingId;

  const ProductDataModel({
    required this.title,
    required this.description,
    required this.image,
    this.price,
    this.discountedPrice,
    this.quantity,
    this.id,
    this.category,
    this.chainId,
    this.createdAt,
    this.store,
    this.stores,
    this.type,
    this.bestByDate,
    this.goLiveDate,
    this.weightedItemsPrices,
    this.listingId
  });

  factory ProductDataModel.fromJson(Map<String, dynamic> json) {
    return ProductDataModel(
      id: json['product_id'] ?? -1,
      listingId: json['listing_id'] ?? -1,
      quantity : json['quantity'] ?? 0,
      title: json['product_name'] ?? '',
      description: json['product_description'] ?? '',
      image: json['product_image'] ?? '',
      price: (json['base_price'] as num?) ?? 0,
      discountedPrice: (json['discounted_price'] as num?) ?? 0,
      type: json['listing_type'] ?? "",
      category: json['category'] != null ? CategoryDataModel.fromJson(json['category']) : null,
      chainId: json['chain_id'] ?? -1,
      createdAt:  DateTime.now(),
      bestByDate : json['best_by_date'] != null && json['best_by_date'] != ''
          ? DateTime.tryParse(json['best_by_date'])
          : null,
      goLiveDate : json['go_live_date'] != null && json['go_live_date'] != ''
          ? DateTime.tryParse(json['go_live_date'])
          : null,
      store: json['store']!= null ?StoreDataModel.fromJson(json['store']) :StoreDataModel(),
      stores: json['stores'] != null ? (json['stores'] as List).map((e)=> StoreDataModel.fromJson(e)).toList() : [],
      weightedItemsPrices : json['weighted_items_prices'] != null
          ? List.from(
              (json['weighted_items_prices'] as List).map((e) => e.toDouble()))
          : [],
      
    );
  }

 Map<String, dynamic> toJson() {
  return {
    'product_id': id,
    'listing_id': listingId,
    'quantity': quantity,
    'product_name': title,
    'product_description': description,
    'product_image': image,
    'base_price': price,
    'discounted_price': discountedPrice,
    'listing_type': type,
    'category': category?.toJson(),
    'chain_id': chainId,
    'created_at': createdAt?.toIso8601String(),
    'best_by_date': bestByDate?.toIso8601String(),
    'go_live_date': goLiveDate?.toIso8601String(),
    'store': store?.toJson(),
    'stores': stores?.map((e) => e.toJson()).toList(),
    'weighted_items_prices': weightedItemsPrices,
  };
}

  ProductDataModel copyWith({
    String? title,
    String? description,
    String? image,
    num? price,
    num? discountedPrice,
    String? type,
    int? quantity


  }) {
    return ProductDataModel(
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      type: type ??this.type,
      quantity: quantity ?? this.quantity
    );
  }
}


class ProductSelectionDataModel extends ProductDataModel {
  final bool isSelect;

  const ProductSelectionDataModel({
    required super.title,
    required super.description,
    required super.image,
    required super.discountedPrice,
    super.bestByDate,
    super.goLiveDate,
    super.price,
    super.type,
    super.quantity,
    required this.isSelect,
  });

  factory ProductSelectionDataModel.fromJson(Map<String, dynamic> json, {bool isSelect = false}) {
    final base = ProductDataModel.fromJson(json);
    return ProductSelectionDataModel(
      title: base.title,
      description: base.description,
      image: base.image,
      price: base.price,
      discountedPrice: base.discountedPrice,
      isSelect: isSelect,
      type: base.type,
      bestByDate: base.bestByDate,
      goLiveDate: base.goLiveDate
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final base = super.toJson();
    base['isSelect'] = isSelect;
    return base;
  }

  @override
  ProductSelectionDataModel copyWith({
    String? title,
    String? description,
    String? image,
    num? price,
    bool? isSelect,
    num? discountedPrice,
    String? type,
    DateTime? bestByDate,
    DateTime? goLiveDate,
    int ? quantity

  }) {
    return ProductSelectionDataModel(
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      isSelect: isSelect ?? this.isSelect,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      type:type ?? this.type,
      bestByDate: bestByDate ?? this.bestByDate,
      goLiveDate: goLiveDate ?? this.goLiveDate,
      quantity: quantity ?? this.quantity

    );
  }
}

class ProductPurchasingDataModel extends ProductDataModel {
   int selectQuantity;
  final num discount;

  ProductPurchasingDataModel({
    required super.title,
    required super.description,
    required super.image,
    super.type,
    super.price,
    super.bestByDate,
    super.goLiveDate,
    super.listingId,
   this.selectQuantity = 0,
    required this.discount,
    super.discountedPrice,
    super.quantity

   
  });

  factory ProductPurchasingDataModel.fromJson(Map<String, dynamic> json,
      {int quantity = 1, num discount = 0}) {
    final base = ProductDataModel.fromJson(json);
    return ProductPurchasingDataModel(
      title: base.title,
      description: base.description,
      image: base.image,
      price: base.price,
      quantity : base.quantity,
      selectQuantity: quantity,
      discount: discount ,
      discountedPrice: base.discountedPrice,
      type: base.type,
      bestByDate: base.bestByDate,
      goLiveDate: base.goLiveDate,
      listingId: base.listingId
      
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final base = super.toJson();
    base.addAll({
      'select_quantity': quantity,
      'discountAmount': discount,
    });
    return base;
  }

  @override
  ProductPurchasingDataModel copyWith({
    String? title,
    String? description,
    String? image,
    num? price,
    int? quantity,
    int? selectQuantity,
    num? discount,
    num? discountedPrice,
    String? type,
    DateTime? bestByDate,
    DateTime? goLiveDate,
    int? listingId
  }) {
    return ProductPurchasingDataModel(
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      discount: discount ?? this.discount,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      type: type ?? this.type,
      bestByDate: bestByDate ?? this.bestByDate,
      goLiveDate: goLiveDate ?? this.goLiveDate,
      selectQuantity: selectQuantity ?? this.selectQuantity,
      listingId: listingId ?? this.listingId
    );
  }
}

