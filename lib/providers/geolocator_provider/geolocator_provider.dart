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
      updateAddressApiResponse: ApiResponse.undertermined(),
      deleteAddressApiResponse: ApiResponse.undertermined(),
      searchLocationsApiResponse: ApiResponse.undertermined(),
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
        if(user.latitude != locationData.latitude || user.longitude != locationData.longitude ){
         ref.read(authProvider.notifier).updateProfile(userDataModel: user.copyWith(
        latitude: locationData.latitude,
        longitude: locationData.longitude,

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

      if (response != null && !(response is Map && response.containsKey('detail'))) {
        LocationDataModel ? loc;
        List temp = response ?? [];
        final List<LocationDataModel> list = List.from(
          temp.map((e) {
            if(e['is_active']){
              loc = LocationDataModel.fromJson(e);
            }
            return LocationDataModel.fromJson(e);
          }),
        );
        state = state.copyWith(
          getAddressesApiResponse: ApiResponse.completed(response),
          addresses: list,
          locationData:list.isEmpty ? LocationDataModel(latitude: 0, longitude: 0) : loc
        );
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("failed_to_get_addresses"),
        );
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

      if (response != null && !(response is Map && response.containsKey('detail'))) {
        final LocationDataModel loc = LocationDataModel.fromJson(response);
        state = state.copyWith(
          addAddressApiResponse: ApiResponse.completed(response),
          locationData: loc.isActive!? loc : null
        );
        AppRouter.customback(times: 2);
        // Optionally refresh addresses after adding
        await getAddresses();
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("failed_to_add_address"),
        );
        AppRouter.back();
        state = state.copyWith(
          addAddressApiResponse: ApiResponse.error(),
        );
      }
    } catch (e) {
      AppRouter.back();
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
      final response = await MyHttpClient.instance.put(ApiEndpoints.activateAddress(addressId), null, isJsonEncode: false);

      if (!ref.mounted) return;

      if (response != null && !(response is Map && response.containsKey('detail'))) {
        final LocationDataModel locationDataModel = LocationDataModel.fromJson(response);
        state = state.copyWith(
          activateAddressApiResponse: ApiResponse.completed(response, ),
          locationData: locationDataModel
        );
        // Refresh addresses after activation
        // await getAddresses();
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("failed_to_activate_address"),
        );
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

  Future<void> searchLocations(String query) async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(searchLocationsApiResponse: ApiResponse.loading());
      final results = await _geolocatorService.searchLocations(query);

      if (!ref.mounted) return;

      state = state.copyWith(
        searchLocationsApiResponse: ApiResponse.completed(results),
        searchResults: results,
      );
    } catch (e) {
      if (!ref.mounted) return;
      Helper.showMessage(
        AppRouter.navKey.currentContext!,
        message: e.toString(),
      );
      state = state.copyWith(searchLocationsApiResponse: ApiResponse.error());
    }
  }

  Future<void> updateAddress(int addressId, Map<String, dynamic> addressData) async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(updateAddressApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.put(ApiEndpoints.address(addressId), addressData);

      if (!ref.mounted) return;

      if (response != null && !(response is Map && response.containsKey('detail'))) {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: "Location Successfully Updated!",
        );
        final LocationDataModel loc = LocationDataModel.fromJson(response);
        state = state.copyWith(
          updateAddressApiResponse: ApiResponse.completed(response),
          locationData: loc.isActive!? loc : null
        );
        AppRouter.customback(times: 2);
        // Optionally refresh addresses after updating
        await getAddresses();
      } else {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("failed_to_update_address"),
        );
        state = state.copyWith(
          updateAddressApiResponse: ApiResponse.error(),
        );
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        updateAddressApiResponse: ApiResponse.error(),
      );
    }
  }

  Future<void> deleteAddress(int addressId) async {
    if (!ref.mounted) return;

    try {
      state = state.copyWith(deleteAddressApiResponse: ApiResponse.loading());
      final response = await MyHttpClient.instance.delete(ApiEndpoints.address(addressId), null);

      if (!ref.mounted) return;

      if (response != null && !(response is Map && response.containsKey('detail'))) {
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: "Successfully Deleted!",
        );
        state = state.copyWith(
          deleteAddressApiResponse: ApiResponse.completed(response),
        );
        // Refresh addresses after deleting
        AppRouter.back();
        await getAddresses();
      } else {
        AppRouter.back();
        Helper.showMessage(
          AppRouter.navKey.currentContext!,
          message: (response is Map && response.containsKey('detail')) ? response['detail'] as String : AppRouter.navKey.currentContext!.tr("failed_to_delete_address"),
        );
        state = state.copyWith(
          deleteAddressApiResponse: ApiResponse.error(),
        );
      }
    } catch (e) {
      AppRouter.back();
      if (!ref.mounted) return;
      state = state.copyWith(
        deleteAddressApiResponse: ApiResponse.error(),
      );
    }
  }




}

final geolocatorProvider = NotifierProvider<GeolocatorProvider, GeolocatorState>(
  GeolocatorProvider.new,
);
