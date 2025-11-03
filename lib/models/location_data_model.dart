class LocationDataModel {
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final double latitude;
  final double longitude;

  LocationDataModel({
    this.address,
    this.city,
    this.state,
    this.country,
    required this.latitude,
    required this.longitude,
  });

  factory LocationDataModel.fromJson(Map<String, dynamic> json) {
    return LocationDataModel(
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  String toString() {
    return 'LocationDataModel(address: $address, city: $city, state: $state, country: $country, latitude: $latitude, longitude: $longitude)';
  }
}
