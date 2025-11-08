import '../../data/network/api_response.dart';
import '../../export_all.dart';

class GeolocatorState {
  final ApiResponse getLocationApiResponse;
  final LocationDataModel? locationData;
  final ApiResponse getAddressesApiResponse;
  final List<AddressDataModel>? addresses;
  final ApiResponse addAddressApiResponse;
  final ApiResponse activateAddressApiResponse;

  GeolocatorState({
    required this.getLocationApiResponse,
    this.locationData,
    required this.getAddressesApiResponse,
    this.addresses,
    required this.addAddressApiResponse,
    required this.activateAddressApiResponse,
  });

  GeolocatorState copyWith({
    ApiResponse? getLocationApiResponse,
    LocationDataModel? locationData,
    ApiResponse? getAddressesApiResponse,
    List<AddressDataModel>? addresses,
    ApiResponse? addAddressApiResponse,
    ApiResponse? activateAddressApiResponse,
  }) => GeolocatorState(
    getLocationApiResponse: getLocationApiResponse ?? this.getLocationApiResponse,
    locationData: locationData ?? this.locationData,
    getAddressesApiResponse: getAddressesApiResponse ?? this.getAddressesApiResponse,
    addresses: addresses ?? this.addresses,
    addAddressApiResponse: addAddressApiResponse ?? this.addAddressApiResponse,
    activateAddressApiResponse: activateAddressApiResponse ?? this.activateAddressApiResponse,
  );
}
