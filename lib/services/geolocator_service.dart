import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:push_price_user/models/location_data_model.dart';

class GeolocatorService {
  Future<LocationDataModel> getCurrentLocation({bool enableBackgroundMode = false}) async {
    // Check permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    // Enable background mode if requested
    if (enableBackgroundMode) {
      await Geolocator.requestPermission();
      // Note: Background location requires additional setup in AndroidManifest.xml and Info.plist
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Reverse geocode to get address details
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark place = placemarks[0];

    return LocationDataModel(
      address: place.street,
      city: place.locality,
      state: place.administrativeArea,
      country: place.country,
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}
