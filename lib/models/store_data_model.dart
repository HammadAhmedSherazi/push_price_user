class StoreDataModel {
  final int storeId;
  final String storeName;
  final String storeLocation;
  final String storeOperationalHours;
  final DateTime? assignedAt;
  final int chainId;
  final String? title;
  final String? address;
  final double? rating;
  final String? icon;

  const StoreDataModel({
    this.storeId = 0,
    this.storeName = '',
    this.storeLocation = '',
    this.storeOperationalHours = '',
    this.assignedAt,
    this.chainId = 0,
    this.title,
    this.address,
    this.rating,
    this.icon,
  });

  factory StoreDataModel.fromJson(Map<String, dynamic> json) {
    return StoreDataModel(
      storeId: json['store_id'] ?? 0,
      storeName: json['store_name'] ?? '',
      storeLocation: json['store_location'] ?? '',
      storeOperationalHours: json['store_operational_hours'] ?? '',
      assignedAt: json['assigned_at'] != null
          ? DateTime.tryParse(json['assigned_at'])
          : null,
      chainId: json['chain_id'] ?? 0,
      title: json['store_name'] ?? '',
      address: json['store_location'] ?? '',
      rating: 0.0,
      icon: json['icon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'store_id': storeId,
        'store_name': storeName,
        'store_location': storeLocation,
        'store_operational_hours': storeOperationalHours,
        'assigned_at': assignedAt?.toIso8601String(),
        'chain_id': chainId,
        'title': title,
        'address': address,
        'rating': rating,
        'icon': icon,
      };
}

class StoreSelectDataModel extends StoreDataModel {
  final bool isSelected;

  const StoreSelectDataModel({
    super.storeId = 0,
    super.storeName = '',
    super.storeLocation = '',
    super.storeOperationalHours = '',
    super.assignedAt,
    super.chainId = 0,
    super.title,
    super.address,
    super.rating,
    super.icon,
    this.isSelected = false,
  });
  factory StoreSelectDataModel.fromJson(Map<String, dynamic> json) {
    return StoreSelectDataModel(
      storeId: json['store_id'] ?? 0,
      storeName: json['store_name'] ?? '',
      storeLocation: json['store_location'] ?? '',
      storeOperationalHours: json['store_operational_hours'] ?? '',
      assignedAt: json['assigned_at'] != null
          ? DateTime.tryParse(json['assigned_at'])
          : null,
      chainId: json['chain_id'] ?? 0,
      title: json['title'],
      address: json['address'],
      rating: json['rating']?.toDouble(),
      icon: json['icon'],
      isSelected: false
    );
  }
  StoreSelectDataModel copyWith({
    int? storeId,
    String? storeName,
    String? storeLocation,
    String? storeOperationalHours,
    DateTime? assignedAt,
    int? chainId,
    String? title,
    String? address,
    double? rating,
    String? icon,
    bool? isSelected,
  }) {
    return StoreSelectDataModel(
      storeId: storeId ?? this.storeId,
      storeName: storeName ?? this.storeName,
      storeLocation: storeLocation ?? this.storeLocation,
      storeOperationalHours:
          storeOperationalHours ?? this.storeOperationalHours,
      assignedAt: assignedAt ?? this.assignedAt,
      chainId: chainId ?? this.chainId,
      title: title ?? this.title,
      address: address ?? this.address,
      rating: rating ?? this.rating,
      icon: icon ?? this.icon,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
