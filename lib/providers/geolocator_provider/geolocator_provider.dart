import 'dart:async';

import 'package:push_price_user/data/network/api_response.dart';
import 'package:push_price_user/export_all.dart';

import 'geolocator_state.dart';

class GeolocatorProvider extends Notifier<GeolocatorState> {
  final GeolocatorService _geolocatorService = GeolocatorService.geolocatorInstance;
  Timer? _travelModeTimer;

  @override
  GeolocatorState build() {
    return GeolocatorState(
      getLocationApiResponse: ApiResponse.undertermined(),
    );
  }

  Future<void> getCurrentLocation() async {
    if (!ref.mounted) return;
    try {
      state = state.copyWith(getLocationApiResponse: ApiResponse.loading());
      final locationData = await _geolocatorService.getCurrentLocation();
      if (!ref.mounted) return;
      state = state.copyWith(
        getLocationApiResponse: ApiResponse.completed(locationData),
        locationData: locationData,
      );
      final user = ref.watch(authProvider.select((e)=>e.userData));
      if(user != null){
        if(user.latitude != locationData.latitude || user.longitude != locationData.longitude){
         ref.read(authProvider.notifier).updateProfile(userDataModel: user.copyWith(
        latitude: locationData.latitude,
        longitude: locationData.longitude
      ));
      }
      }
      
     
    } catch (e) {
      if (!ref.mounted) return;
      Helper.showMessage(
        AppRouter.navKey.currentContext!,
        message: e.toString(),
      );
      state = state.copyWith(getLocationApiResponse: ApiResponse.error());
    }
  }

  void toggleTravelMode(bool enabled) async {
    if (enabled) {
      // Check and request permissions in foreground before starting travel mode
      try {
        await _geolocatorService.getCurrentLocation(enableBackgroundMode: true);
        startTravelMode();
      } catch (e) {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: e.toString(),
        );
        return; // Don't enable if permissions failed
      }
    } else {
      stopTravelMode();
    }
    state = state.copyWith(isTravelModeEnabled: enabled);
    ref.read(authProvider.notifier).toggleTravelMode(enabled);
    final user = ref.watch(authProvider.select((e)=>e.userData))!;
    ref.read(authProvider.notifier).updateProfile(userDataModel: user.copyWith(isTravelMode: enabled));
  }

  void startTravelMode() {
    // Start periodic location updates every 15 seconds
    _travelModeTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _geolocatorService.getCurrentLocation(enableBackgroundMode: true, skipPermissions: true);
    });
  }

  void stopTravelMode() {
    _travelModeTimer?.cancel();
    _travelModeTimer = null;
  }


}

final geolocatorProvider = NotifierProvider<GeolocatorProvider, GeolocatorState>(
  GeolocatorProvider.new,
);
