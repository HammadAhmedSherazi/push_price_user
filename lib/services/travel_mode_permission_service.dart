import 'dart:io';

import 'package:geolocator/geolocator.dart';

import 'notification_service.dart';

class TravelModePermissionException implements Exception {
  final String messageKey;
  final bool openSettings;

  const TravelModePermissionException(
    this.messageKey, {
    this.openSettings = false,
  });
}

class TravelModePermissionService {
  TravelModePermissionService._();

  static final TravelModePermissionService instance =
      TravelModePermissionService._();

  Future<void> ensureReadyForTravelMode() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const TravelModePermissionException('location_services_disabled');
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw const TravelModePermissionException(
        'location_permission_denied',
        openSettings: true,
      );
    }

    if (permission == LocationPermission.whileInUse) {
      permission = await Geolocator.requestPermission();
    }

    if (permission != LocationPermission.always) {
      throw const TravelModePermissionException(
        'travel_mode_background_permission_required',
        openSettings: true,
      );
    }
  }

  Future<void> ensureForegroundServiceCanStart() async {
    final permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.always) {
      throw const TravelModePermissionException(
        'travel_mode_background_permission_required',
        openSettings: true,
      );
    }

    if (Platform.isAndroid) {
      await NotificationService.ensureForegroundServiceChannel();
      await NotificationService.requestAndroidNotificationPermission();
    }
  }
}
