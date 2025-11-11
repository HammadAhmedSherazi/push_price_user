import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:push_price_user/export_all.dart';
import 'package:push_price_user/models/place_detail_model.dart';
import 'package:push_price_user/models/place_listing_model.dart';

class GeolocatorService {
  GeolocatorService._();

  static final GeolocatorService _singleton = GeolocatorService._();

  static GeolocatorService get geolocatorInstance => _singleton;

  Future<LocationDataModel> getCurrentLocation({bool enableBackgroundMode = false, bool skipPermissions = false}) async {
    // Check permissions unless skipped (for background calls)
    if (!skipPermissions) {
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
    }

    // Get current position with timeout and background-friendly settings
    // In background (skipPermissions=true), use more lenient settings
    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: skipPermissions ? LocationAccuracy.medium : LocationAccuracy.high,
          timeLimit: skipPermissions ? const Duration(seconds: 20) : const Duration(seconds: 10),
          distanceFilter: skipPermissions ? 10 : 0, // Filter small movements in background
        ),
      ).timeout(
        skipPermissions ? const Duration(seconds: 20) : const Duration(seconds: 10),
      );
    } catch (e) {
      // If getCurrentPosition fails (common in background), try to get last known position
      Position? lastKnownPosition = await Geolocator.getLastKnownPosition();
      if (lastKnownPosition != null) {
        // Use last known position if available (better than nothing)
        position = lastKnownPosition;
      } else {
        // If we can't get any position, throw the original error
        throw Exception('Failed to get location: ${e.toString()}');
      }
    }

    // Try to reverse geocode, but don't fail if it doesn't work (common in background)
    String address = '';
    String city = '';
    String state = '';
    String country = '';
    String postalCode = '';
    
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      ).timeout(const Duration(seconds: 5));

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        address = place.street ?? '';
        city = place.locality ?? '';
        state = place.administrativeArea ?? '';
        country = place.country ?? '';
        postalCode = place.postalCode ?? "";
      
      }
    } catch (e) {
      // Geocoding failed (common in background), continue with empty address fields
      // We still have lat/long which is what we need
    }

    return LocationDataModel(
      label: address,
      addressLine1: address,
      addressLine2: address,
      city: city,
      state: state,
      country: country,
      latitude: position.latitude,
      longitude: position.longitude,
      postalCode: postalCode
    );
  }

  Future<List<LocationDataModel>> searchLocations(String query) async {
    try {
      final PlaceListingModel? data = await GoogleMapServices.googleMapServiceInstance.getPlaceListing(query);
      if (data == null || data.predictions == null) {
        return [];
      }

      List<LocationDataModel> results = [];

      for (Prediction prediction in data.predictions!) {
        // Get place details to get lat/lng
        final PlaceDetailModel? detail = await GoogleMapServices.googleMapServiceInstance.getPlaceDetails(prediction.placeId!);
        if (detail != null && detail.result != null && detail.result!.geometry != null && detail.result!.geometry!.location != null) {
          final loc = detail.result!.geometry!.location!;

          // Reverse geocode to get city, state, country
          String city = '';
          String state = '';
          String country = '';
          String postalCode = '';
          try {
            List<Placemark> placemarks = await placemarkFromCoordinates(
              loc.lat ?? 0.0,
              loc.lng ?? 0.0,
            ).timeout(const Duration(seconds: 5));

            if (placemarks.isNotEmpty) {
              Placemark place = placemarks[0];
              city = place.locality ?? '';
              state = place.administrativeArea ?? '';
              country = place.country ?? '';
              postalCode = place.postalCode ?? '';
            }
          } catch (e) {
            // Geocoding failed, continue with empty fields
          }

          results.add(LocationDataModel(
            label: prediction.description ?? '',
            addressLine1: prediction.description ?? '',
            addressLine2: prediction.description ?? "",
            city: city,
            state: state,
            country: country,
            latitude: loc.lat ?? 0.0,
            longitude: loc.lng ?? 0.0,
            postalCode: postalCode
          ));
        }
      }

      return results;
    } catch (e) {
      throw Exception('Failed to search locations: ${e.toString()}');
    }
  }

  
  
 
}
