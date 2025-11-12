import '../../data/network/api_response.dart';
import '../../export_all.dart';

class GeolocatorState {
  final ApiResponse getLocationApiResponse;
  final LocationDataModel? locationData;
  final ApiResponse getAddressesApiResponse;
  final List<LocationDataModel>? addresses;
  final ApiResponse addAddressApiResponse;
  final ApiResponse activateAddressApiResponse;
  final ApiResponse updateAddressApiResponse;
  final ApiResponse deleteAddressApiResponse;
  final ApiResponse searchLocationsApiResponse;
  final List<LocationDataModel>? searchResults;

  GeolocatorState({
    required this.getLocationApiResponse,
    this.locationData,
    required this.getAddressesApiResponse,
    this.addresses,
    required this.addAddressApiResponse,
    required this.activateAddressApiResponse,
    required this.updateAddressApiResponse,
    required this.deleteAddressApiResponse,
    required this.searchLocationsApiResponse,
    this.searchResults,
  });

  GeolocatorState copyWith({
    ApiResponse? getLocationApiResponse,
    LocationDataModel? locationData,
    ApiResponse? getAddressesApiResponse,
    List<LocationDataModel>? addresses,
    ApiResponse? addAddressApiResponse,
    ApiResponse? activateAddressApiResponse,
    ApiResponse? updateAddressApiResponse,
    ApiResponse? deleteAddressApiResponse,
    ApiResponse? searchLocationsApiResponse,
    List<LocationDataModel>? searchResults,
  }) => GeolocatorState(
    getLocationApiResponse: getLocationApiResponse ?? this.getLocationApiResponse,
    locationData: locationData ?? this.locationData,
    getAddressesApiResponse: getAddressesApiResponse ?? this.getAddressesApiResponse,
    addresses: addresses ?? this.addresses,
    addAddressApiResponse: addAddressApiResponse ?? this.addAddressApiResponse,
    activateAddressApiResponse: activateAddressApiResponse ?? this.activateAddressApiResponse,
    updateAddressApiResponse: updateAddressApiResponse ?? this.updateAddressApiResponse,
    deleteAddressApiResponse: deleteAddressApiResponse ?? this.deleteAddressApiResponse,
    searchLocationsApiResponse: searchLocationsApiResponse ?? this.searchLocationsApiResponse,
    searchResults: searchResults ?? this.searchResults,
  );
}
