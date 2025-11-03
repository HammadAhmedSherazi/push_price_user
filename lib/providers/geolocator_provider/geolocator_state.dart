import '../../data/network/api_response.dart';
import '../../export_all.dart';

class GeolocatorState {
  final ApiResponse getLocationApiResponse;
  final LocationDataModel? locationData;


  GeolocatorState({
    required this.getLocationApiResponse,
    this.locationData,

  });

  GeolocatorState copyWith({
    ApiResponse? getLocationApiResponse,
    LocationDataModel? locationData,
    bool? isTravelModeEnabled,
  }) => GeolocatorState(
    getLocationApiResponse: getLocationApiResponse ?? this.getLocationApiResponse,
    locationData: locationData ?? this.locationData,

  );
}
