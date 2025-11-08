class AddressDataModel {
  final String label;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final double latitude;
  final double longitude;
  final int addressId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  AddressDataModel({
    required this.label,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.addressId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddressDataModel.fromJson(Map<String, dynamic> json) {
    return AddressDataModel(
      label: json['label'],
      addressLine1: json['address_line1'],
      addressLine2: json['address_line2'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postal_code'],
      country: json['country'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      addressId: json['address_id'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'address_line1': addressLine1,
      'address_line2': addressLine2,
      'city': city,
      'state': state,
      'postal_code': postalCode,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'address_id': addressId,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'AddressDataModel(label: $label, addressLine1: $addressLine1, addressLine2: $addressLine2, city: $city, state: $state, postalCode: $postalCode, country: $country, latitude: $latitude, longitude: $longitude, addressId: $addressId, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
