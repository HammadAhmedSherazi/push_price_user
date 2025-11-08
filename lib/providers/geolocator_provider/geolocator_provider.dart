import 'dart:async';

import 'package:push_price_user/data/network/api_response.dart';
import 'package:push_price_user/export_all.dart';

import 'geolocator_state.dart';

class GeolocatorProvider extends Notifier<GeolocatorState> {
  final GeolocatorService _geolocatorService = GeolocatorService.geolocatorInstance;
  // Timer? _travelModeTimer;

  @override
  GeolocatorState build() {
    // Load persisted location data

    return GeolocatorState(
      getLocationApiResponse: ApiResponse.undertermined(),
      getAddressesApiResponse: ApiResponse.undertermined(),
      addAddressApiResponse: ApiResponse.undertermined(),
      activateAddressApiResponse: ApiResponse.undertermined(),
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
      final user = ref.read(authProvider.select((e)=>e.userData));
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

      } catch (e) {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: e.toString(),
        );
        return; // Don't enable if permissions failed
      }
    } else {

    }
    state = state.copyWith(locationData: state.locationData);
    ref.read(authProvider.notifier).toggleTravelMode(enabled);
    final user = ref.read(authProvider.select((e)=>e.userData))!;
    ref.read(authProvider.notifier).updateProfile(userDataModel: user.copyWith(isTravelMode: enabled));
  }

  Future<void> getAddresses() async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(getAddressesApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.get(ApiEndpoints.getAddresses);

      if (!ref.mounted) return;

      if (response != null) {
        List temp = response ?? [];
        final List<AddressDataModel> list = List.from(
          temp.map((e) => AddressDataModel.fromJson(e)),
        );
        state = state.copyWith(
          getAddressesApiResponse: ApiResponse.completed(response),
          addresses: list,
        );
      } else {
        state = state.copyWith(
          getAddressesApiResponse: ApiResponse.error(),
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        getAddressesApiResponse: ApiResponse.error(),
      );
    }
  }

  Future<void> addAddress(Map<String, dynamic> addressData) async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(addAddressApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.post(ApiEndpoints.getAddresses, addressData);

      if (!ref.mounted) return;

      if (response != null) {
        state = state.copyWith(
          addAddressApiResponse: ApiResponse.completed(response),
        );
        // Optionally refresh addresses after adding
        await getAddresses();
      } else {
        state = state.copyWith(
          addAddressApiResponse: ApiResponse.error(),
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        addAddressApiResponse: ApiResponse.error(),
      );
    }
  }

  Future<void> activateAddress(int addressId) async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(activateAddressApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.put(ApiEndpoints.activateAddress(addressId), {});

      if (!ref.mounted) return;

      if (response != null) {
        state = state.copyWith(
          activateAddressApiResponse: ApiResponse.completed(response),
        );
        // Refresh addresses after activation
        await getAddresses();
      } else {
        state = state.copyWith(
          activateAddressApiResponse: ApiResponse.error(),
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        activateAddressApiResponse: ApiResponse.error(),
      );
    }
  }




}

final geolocatorProvider = NotifierProvider<GeolocatorProvider, GeolocatorState>(
  GeolocatorProvider.new,
);
