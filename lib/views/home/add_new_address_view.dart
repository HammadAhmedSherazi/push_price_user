import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../export_all.dart';

class AddNewAddressView extends StatefulWidget {
  const AddNewAddressView({super.key});

  @override
  State<AddNewAddressView> createState() => _AddNewAddressViewState();
}

class _AddNewAddressViewState extends State<AddNewAddressView> {
  final TextEditingController searchTextController = TextEditingController();

  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  Set<Marker> _markers = {};
  LocationDataModel? _selectedLocationData;

  @override
  void initState() {
    super.initState();
    // Get current location when view opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Will be handled in build method with ref
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onMapTap(LatLng position) async {
    setState(() {
      _selectedLocation = position;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('selected_location'),
          position: position,
        ),
      );
    });

    // Reverse geocode the selected location
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        _selectedLocationData = LocationDataModel(
          address: place.street ?? '',
          city: place.locality ?? '',
          state: place.administrativeArea ?? '',
          country: place.country ?? '',
          latitude: position.latitude,
          longitude: position.longitude,
        );
      }
    } catch (e) {
      // Handle error silently
      _selectedLocationData = LocationDataModel(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    }
  }

  void _selectSearchResult(LocationDataModel location) {
    final latLng = LatLng(location.latitude, location.longitude);
    setState(() {
      _selectedLocation = latLng;
      _selectedLocationData = location;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('selected_location'),
          position: latLng,
        ),
      );
    });

    // Move camera to selected location
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(latLng, 15),
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(
      showBottomButton: true,
      customBottomWidget: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.horizontalPadding
        ),
        child: CustomButtonWidget(
          onPressed: (){
            
          },
          title: "Add Address",
        ),
      ),
      title: "Add New Address",
      child: Consumer(
        builder: (context, ref, child) {
          final locationData = ref.watch(geolocatorProvider.select((e) => e.locationData));
          final searchState = ref.watch(geolocatorProvider.select((e) => e.searchLocationsApiResponse));
          final searchResults = ref.watch(geolocatorProvider.select((e) => e.searchResults));

          // Get current location on first build
          if (locationData == null) {
            ref.read(geolocatorProvider.notifier).getCurrentLocation();
          }

          // Set initial map position and marker
          LatLng initialPosition = const LatLng(37.7749, -122.4194); // Default to San Francisco
          if (locationData != null) {
            initialPosition = LatLng(locationData.latitude, locationData.longitude);
            // Always show current location marker
            _markers.removeWhere((marker) => marker.markerId.value == 'current_location');
            _markers.add(
              Marker(
                markerId: const MarkerId('current_location'),
                position: initialPosition,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
              ),
            );
            // Set selected location to current location if not already set
            if (_selectedLocation == null) {
              _selectedLocation = initialPosition;
              _selectedLocationData = locationData;
            }
          }

          return Stack(
            children: [
              // Map
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: initialPosition,
                  zoom: 15,
                ),
                markers: _markers,
                onTap: _onMapTap,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),

              // Search Bar on top
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: CustomSearchBarWidget(
                  controller: searchTextController,
                  hintText: "Search location...",
                  onChanged: (value){
                if (searchTextController.text.isNotEmpty) {
                          ref.read(geolocatorProvider.notifier).searchLocations(searchTextController.text);
                        }
                  },
                  
                
                ),
              ),
              

              // Search Results
              if (searchState.status == Status.loading)
                Positioned(
                  top: 80,
                  left: 16,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  ),
                )
              else if (searchResults != null && searchResults.isNotEmpty)
                Positioned(
                  top: 80,
                  left: 16,
                  right: 16,
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final result = searchResults[index];
                        return ListTile(
                          title: Text(result.address ?? 'Unknown Address'),
                          subtitle: Text('${result.city}, ${result.state}'),
                          onTap: () => _selectSearchResult(result),
                        );
                      },
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
