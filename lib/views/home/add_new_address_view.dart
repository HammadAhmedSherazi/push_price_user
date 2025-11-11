import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:push_price_user/utils/extension.dart';

import '../../export_all.dart';

class AddNewAddressView extends ConsumerStatefulWidget {
  final LocationDataModel? addressToEdit;
  const AddNewAddressView({super.key, this.addressToEdit});

  @override
  ConsumerState<AddNewAddressView> createState() => _AddNewAddressViewState();
}

class _AddNewAddressViewState extends ConsumerState<AddNewAddressView> {
  final TextEditingController searchTextController = TextEditingController();

  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  final Set<Marker> _markers = {};
  LocationDataModel? _selectedLocationData;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    // Initialize with edit data if provided
    if (widget.addressToEdit != null) {
     _selectSearchResult(widget.addressToEdit!);
    }
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
          addressLine1: place.street ?? '',
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
      searchTextController.text = _selectedLocationData?.addressLine1 ?? "";
      showSearchDialog = false;
      _markers.clear();
      _markers.add(
        Marker(markerId: const MarkerId('selected_location'), position: latLng),
      );
    });

    // Move camera to selected location
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));
  }

  bool showSearchDialog = false;

  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(
      showBottomButton: _selectedLocationData != null,
      customBottomWidget: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding),
        child: Consumer(
          builder: (context, ref, child) {
            final isLoad = ref.watch(geolocatorProvider.select((e)=>e.addAddressApiResponse.status)) == Status.loading;
            return CustomButtonWidget(
              isLoad: isLoad,
              onPressed: () {
              showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          builder: (bottomSheetContext) {
                            final TextEditingController labelController =  TextEditingController(text: widget.addressToEdit!= null?  widget.addressToEdit?.label ??  "" : null);
                            final GlobalKey<FormState> formKey = GlobalKey<FormState>();
                            return Padding(
                              padding: EdgeInsets.all(AppTheme.horizontalPadding).copyWith(
                                bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 20,
                              ),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                   
                                    TextFormField(
                                      controller: labelController,
                                      decoration: InputDecoration(
                                        labelText: "Address Label",
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return "Please enter an address label";
                                        }
                                        return null;
                                      },
                                    ),
                                    20.ph,
                                    Consumer(
                                      builder: (context, ref, child) {
                                        final locationData = ref.watch(geolocatorProvider.select((e) => e.locationData));
                                        final isLoading = ref.watch(geolocatorProvider.select((e) => e.addAddressApiResponse.status == Status.loading));
                                        return CustomButtonWidget(
                                          isLoad: isLoading,
                                          onPressed: () {
                                            if (formKey.currentState?.validate() == true && locationData != null) {
                                              final updatedData = _selectedLocationData!.copyWith(
                                                label: labelController.text.trim()
                                              );
                                              ref.read(geolocatorProvider.notifier).addAddress(updatedData.toJson());
                                               // close bottom sheet
                                            } else if (locationData == null) {
                                              // Handle case where location data is not available
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text("Location data not available. Please try again.")),
                                              );
                                            }
                                          },
                                          title: widget.addressToEdit != null ? "Update Address" : "Done",
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                     
              // ref.read(geolocatorProvider.notifier).addAddress(_selectedLocationData!.toJson());
            }, title: "Add Address");
          }
        ),
      ),
      title: widget.addressToEdit != null ? "Edit Address" : "Add New Address",
      child: Consumer(
        builder: (context, ref, child) {
          final locationData = widget.addressToEdit ?? ref.watch(
            geolocatorProvider.select((e) => e.locationData),
          );
          final searchState = ref.watch(
            geolocatorProvider.select((e) => e.searchLocationsApiResponse),
          );
          final searchResults = ref.watch(
            geolocatorProvider.select((e) => e.searchResults),
          ) ?? [];

          // Get current location on first build
          if (locationData == null) {
            ref.read(geolocatorProvider.notifier).getCurrentLocation();
          }

          // Set initial map position and marker
          LatLng initialPosition = const LatLng(
            37.7749,
            -122.4194,
          ); // Default to San Francisco
          if (locationData  != null) {
            initialPosition = LatLng(
              locationData.latitude,
              locationData.longitude,
            );
            // Always show current location marker
            _markers.removeWhere(
              (marker) => marker.markerId.value == 'current_location',
            );
            _markers.add(
              Marker(
                markerId: const MarkerId('current_location'),
                position: initialPosition,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed,
                ),
              ),
            );
            // Set selected location to current location if not already set
            // if (_selectedLocation == null) {
            //   _selectedLocation = initialPosition;
            //   _selectedLocationData = locationData;
            // }
          }

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Map
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: initialPosition,
                  zoom: 15,
                ),
                markers: _markers,
                onTap: null,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
              ),
          
              // Search Bar on top
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: CustomSearchBarWidget(
                  controller: searchTextController,
                  onTapOutside: (status) {
                    FocusScope.of(context).unfocus();
                    
                  },
                  hintText: "Search location...",
                  onChanged: (value) {
                    if (searchTextController.text.isNotEmpty) {
                      if (_searchDebounce?.isActive ?? false) {
                        _searchDebounce!.cancel();
                      }
          
                      _searchDebounce = Timer(
                        const Duration(milliseconds: 500),
                        () {
                          if (value.length >= 3) {
                            ref
                                .read(geolocatorProvider.notifier)
                                .searchLocations(searchTextController.text);
                            showSearchDialog = true;
                          }
                          // else{
                          //   fetchProduct(skip: 0);
                          // }
                        },
                      );
                    } else {
                      showSearchDialog = false;
                      setState(() {
                        
                      });
                    }
                  },
                ),
              ),
          
              if (showSearchDialog)
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
                    child: Column(
                      children: [
                       
                        Expanded(
                          child: AsyncStateHandler(
                            dataList: searchResults ,
                           
                            status: searchState.status,
                            onRetry: () {},
                            itemBuilder: (context, index) {
                              final result = searchResults[index];
                              return  ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      visualDensity: VisualDensity(horizontal: -4.0, vertical: -3.0),
                                      minLeadingWidth: 10,
                                      leading: Icon(
                                        Icons.location_pin,
                                        color: Colors.red,
                                      ),
                                      title: Text(
                                        result.addressLine1 ??
                                            '${result.city}, ${result.state}',
                                      ),
                                      // trailing: GestureDetector(
                                      //   onTap: () {
                                      //     searchTextController.text =
                                      //         result.address ??
                                      //         '${result.city}, ${result.state}';
                                      //     setState(() {
                                      //       showSearchDialog = false;
                                      //     });
                                      //   },
                                      //   child: Transform.rotate(
                                      //     // The angle is in radians. math.pi / 4 is 45 degrees.
                                      //     // Positive angle rotates clockwise.
                                      //     angle:
                                      //         -math.pi /
                                      //         4, // for up-left, use math.pi / 4 for up-right if starting from horizontal
                                      //     child: Icon(
                                      //       Icons
                                      //           .arrow_upward, // This icon points straight up by default
                                      //       size: 22.r,
                                      //     ),
                                      //   ),
                                      // ),
                          
                                      onTap: () => _selectSearchResult(result),
                                    );
                            },
                          ),
                        ),
                         if(searchState.status == Status.completed)
                        ListTile(
                          
                                leading: Transform.rotate(
                                  angle: 45,
                                  child: Icon(
                                    Icons.navigation,
                                    color: Colors.teal,
                                  ),
                                ),
                                visualDensity: VisualDensity(
                                  horizontal: -4.0,
                                  vertical: -4.0,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: AppTheme.horizontalPadding
                                ),
                                title: Text('Use My Current Location'),
                                onTap: () {
                                  ref
                                      .read(geolocatorProvider.notifier)
                                      .getCurrentLocation();
                                },
                              ),
                      ],
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
