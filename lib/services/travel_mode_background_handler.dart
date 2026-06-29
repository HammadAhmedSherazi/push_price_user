import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';

import '../models/location_data_model.dart';
import 'background_location_service.dart';
import 'geolocator_service.dart';
import 'secure_storage.dart';

Timer? _locationTimer;
bool _stopServiceListenerRegistered = false;

Future<void> performLocationUpdate(ServiceInstance service) async {
  try {
    final hasToken = await SecureStorageManager.sharedInstance.hasToken();
    final userJsonData =
        await SecureStorageManager.sharedInstance.getUserData();
    if (userJsonData == null || !hasToken) return;

    final userData = await compute(parseUserJson, userJsonData);
    if (!userData.isTravelMode) {
      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
          title: 'Background Location Service',
          content: 'Travel mode is off',
        );
      }
      return;
    }

    LocationDataModel locationData;
    if (service is AndroidServiceInstance) {
      locationData = await GeolocatorService.geolocatorInstance
          .getCurrentLocation(skipPermissions: true);
    } else {
      try {
        locationData = await GeolocatorService.geolocatorInstance
            .getCurrentLocation(skipPermissions: true)
            .timeout(const Duration(seconds: 15));
      } catch (e) {
        final lastPosition = await Geolocator.getLastKnownPosition();
        if (lastPosition == null) {
          throw Exception('Unable to get location: ${e.toString()}');
        }
        locationData = LocationDataModel(
          latitude: lastPosition.latitude,
          longitude: lastPosition.longitude,
          addressLine1: '',
          city: '',
          state: '',
          country: '',
        );
      }
    }

    final locationString =
        'Lat: ${locationData.latitude.toStringAsFixed(6)}, Long: ${locationData.longitude.toStringAsFixed(6)}';

    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: 'Travel Mode Active',
        content: locationString,
      );
    }

    await BackgroundLocationService.updateTravelModeLocation(
      userData: userData,
      latitude: locationData.latitude,
      longitude: locationData.longitude,
    );
  } catch (e) {
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: 'Location Error',
        content: 'Error: $e',
      );
    }
  }
}

void startLocationUpdates(ServiceInstance service) {
  _locationTimer?.cancel();
  _locationTimer = Timer.periodic(
    const Duration(seconds: 15),
    (_) => performLocationUpdate(service),
  );
  performLocationUpdate(service);
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  startLocationUpdates(service);
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.setForegroundNotificationInfo(
      title: 'Background Location Service',
      content: 'Initializing...',
    );
  }

  startLocationUpdates(service);

  if (!_stopServiceListenerRegistered) {
    _stopServiceListenerRegistered = true;
    service.on('stopService').listen((_) {
      _locationTimer?.cancel();
      _locationTimer = null;
      if (service is AndroidServiceInstance) {
        service.setAsBackgroundService();
      }
      service.stopSelf();
    });
  }
}
