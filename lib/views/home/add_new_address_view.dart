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
  /// Store camera position during drag; on idle we update selected location from center.
  CameraPosition? _lastCameraPosition;

  @override
  void initState() {
    super.initState();
    // Initialize with edit data if provided
    if (widget.addressToEdit != null) {
      _selectSearchResult(widget.addressToEdit!);
    }
    final locationData = ref.read(geolocatorProvider.select((e)=>e.locationData));
     if (locationData == null) {
      Future.microtask((){
        ref.read(geolocatorProvider.notifier).getCurrentLocation();
      });
          }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // Set initial center so first onCameraIdle can update address
    controller.getVisibleRegion().then((bounds) {
      if (!mounted) return;
      final center = LatLng(
        (bounds.southwest.latitude + bounds.northeast.latitude) / 2,
        (bounds.southwest.longitude + bounds.northeast.longitude) / 2,
      );
      _lastCameraPosition = CameraPosition(target: center, zoom: 15);
    });
  }

  /// When map center changes (tap or camera idle after drag) - update selected location and reverse geocode.
  /// Pin is fixed at screen center; moving the map updates the location under the pin.
  Future<void> _onLocationSelectedFromMap(LatLng position) async {
    setState(() {
      _selectedLocation = position;
      _markers.removeWhere((m) => m.markerId.value == 'selected_location');
    });

    try {
      Placemark? place = await GeolocatorService.getLocationDetail(
        lat: position.latitude,
        lon: position.longitude,
      );
      String city = place?.locality ?? "";
      String state = place?.administrativeArea ?? "";
      String country = place?.country ?? "";
      String postalCode = place?.postalCode ?? "";
      String addressLine1 = place?.street ?? "";
      if (addressLine1.isEmpty) addressLine1 = "$state, $city $country".trim();
      if (!mounted) return;
      setState(() {
        _selectedLocationData = LocationDataModel(
          addressLine1: addressLine1,
          addressLine2: place?.subThoroughfare ?? "",
          city: city,
          state: state,
          country: country,
          postalCode: postalCode,
          latitude: position.latitude,
          longitude: position.longitude,
        );
        searchTextController.text = _selectedLocationData?.addressLine1 ?? "";
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _selectedLocationData = LocationDataModel(
          latitude: position.latitude,
          longitude: position.longitude,
        );
        searchTextController.text = "";
      });
    }
  }

  Future<void> _selectSearchResult(LocationDataModel location) async {
    final latLng = LatLng(location.latitude, location.longitude);
    Placemark? place = await GeolocatorService.getLocationDetail(
      lat: location.latitude,
      lon: location.longitude,
    );
    String city = place?.locality ?? "";
    String state = place?.administrativeArea ?? "";
    String country = place?.country ?? "";
    String postalCode = place?.postalCode ?? "";
    setState(() {
      _selectedLocation = latLng;
      _selectedLocationData = location.copyWith(
        city: city,
        country: country,
        postalCode: postalCode,
        state: state,
        addressLine1: location.addressLine1 == ""
            ? place?.street == null || place?.street == "" ? "$state, $city $country" : place?.street
            : location.addressLine1,
        addressLine2: location.addressLine2 == ""
            ? place?.street == null || place?.street == "" ? "$state, $city $country" : place?.street
            : location.addressLine2,
      );
      searchTextController.text = _selectedLocationData?.addressLine1 ?? "";
      showSearchDialog = false;
      _markers.removeWhere((m) => m.markerId.value == 'selected_location');
    });

    // Animate camera so center pin moves to this location
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
            final isLoad =
                ref.watch(
                  geolocatorProvider.select(
                    (e) => e.addAddressApiResponse.status,
                  ),
                ) ==
                Status.loading;
            return CustomButtonWidget(
              isLoad: isLoad,
              onPressed: () {
                final labelController = TextEditingController(
                  text: widget.addressToEdit?.label ?? "",
                );
                final formKey = GlobalKey<FormState>();
                final FocusNode focusNode = FocusNode();
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  builder: (bottomSheetContext) {
                    // final TextEditingController labelController =
                    //     TextEditingController(
                    //       text: widget.addressToEdit != null
                    //           ? widget.addressToEdit?.label ?? ""
                    //           : null,
                    //     );
                    // final GlobalKey<FormState> formKey = GlobalKey<FormState>();
                    // final FocusNode focusNode = FocusNode();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      focusNode.requestFocus();
                    });
                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(AppTheme.horizontalPadding)
                            .copyWith(
                              bottom:
                                  MediaQuery.of(
                                    bottomSheetContext,
                                  ).viewInsets.bottom +
                                  20,
                            ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                focusNode: focusNode,
                                controller: labelController,
                                decoration: InputDecoration(
                                  labelText: context.tr("address_label"),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return context.tr(
                                      "please_enter_an_address_label",
                                    );
                                  }
                                  return null;
                                },
                              ),
                              20.ph,
                              Consumer(
                                builder: (context, ref, child) {
                                  // final locationData = ref.watch(
                                  //   geolocatorProvider.select(
                                  //     (e) => e.locationData,
                                  //   ),
                                  // );
                                  final isLoading = ref.watch(
                                    geolocatorProvider.select(
                                      (e) => widget.addressToEdit != null
                                          ? e.updateAddressApiResponse.status ==
                                                Status.loading
                                          : e.addAddressApiResponse.status ==
                                                Status.loading,
                                    ),
                                  );
                                  return CustomButtonWidget(
                                    isLoad: isLoading,
                                    onPressed: () {
                                      if (formKey.currentState?.validate() ==
                                              true &&
                                          _selectedLocationData != null) {
                                        final updatedData =
                                            _selectedLocationData!.copyWith(
                                              label: labelController.text
                                                  .trim(),
                                              isActive: widget
                                                  .addressToEdit
                                                  ?.isActive,
                                            );
                                        if (widget.addressToEdit != null) {
                                          ref
                                              .read(geolocatorProvider.notifier)
                                              .updateAddress(
                                                widget
                                                    .addressToEdit!
                                                    .addressId!,
                                                updatedData.toJson(),
                                              );
                                        } else {
                                          ref
                                              .read(geolocatorProvider.notifier)
                                              .addAddress(updatedData.toJson());
                                        }
                                        // close bottom sheet
                                      } else if (_selectedLocationData ==
                                          null) {
                                        // Handle case where location data is not available
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              context.tr(
                                                "location_data_not_available_please_try_again",
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    title: widget.addressToEdit != null
                                        ? context.tr("update_address")
                                        : context.tr("add_address"),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );

                // ref.read(geolocatorProvider.notifier).addAddress(_selectedLocationData!.toJson());
              },
              title: widget.addressToEdit != null
                  ? context.tr("edit_address")
                  : context.tr("add_address"),
            );
          },
        ),
      ),
      title: widget.addressToEdit != null
          ? context.tr("edit_address")
          : context.tr("add_new_address"),
      child: Consumer(
        builder: (context, ref, child) {
          final locationData =
              widget.addressToEdit ??
              ref.watch(geolocatorProvider.select((e) => e.locationData));
          final searchState = ref.watch(
            geolocatorProvider.select((e) => e.searchLocationsApiResponse),
          );
          final searchResults =
              ref.watch(geolocatorProvider.select((e) => e.searchResults)) ??
              [];

          // Set initial map position and marker; show pin from current location so user can drag it (Foodpanda-style)
          LatLng initialPosition = const LatLng(
            37.7749,
            -122.4194,
          ); // Default to San Francisco
          if (locationData != null && locationData.latitude != 0.0 && locationData.longitude != 0.0) {
            initialPosition = LatLng(
              locationData.latitude,
              locationData.longitude,
            );
            // When no edit and no selection yet, set initial pin at current location so user sees pin and can drag (Foodpanda-style)
            if (widget.addressToEdit == null && _selectedLocation == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_selectedLocation == null && mounted) {
                  _selectSearchResult(locationData);
                }
              });
            }
          }

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Map: center pin stays fixed; moving map updates selected location on camera idle
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: initialPosition,
                  zoom: 15,
                ),
                markers: _markers,
                onCameraMove: (CameraPosition position) {
                  _lastCameraPosition = position;
                },
                onCameraIdle: () {
                  if (_lastCameraPosition != null && mounted) {
                    _onLocationSelectedFromMap(_lastCameraPosition!.target);
                  }
                },
                onTap: (LatLng position) {
                  // Animate camera to tapped point; pin follows. onCameraIdle will update address.
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(position, 15),
                  );
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
              ),
              // Fixed center pin: map move karein to pin center me rahe, location update camera idle pe
              Positioned.fill(
                child: IgnorePointer(
                  child: Center(
                    child: TweenAnimationBuilder<double>(
                      key: ValueKey(_selectedLocation?.latitude),
                      tween: Tween(begin: 0.9, end: 1.0),
                      duration: const Duration(milliseconds: 200),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Icon(
                            Icons.location_pin,
                            size: 56,
                            color: Colors.red,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 20.r,
                right: 20.r,
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () async {
                    final user = ref.watch(
                      authProvider.select((e) => e.userData),
                    );
                    double? lat = double.tryParse("${user?.latitude}");
                    double? lon = double.tryParse("${user?.longitude}");
                    if (lat == 0.0 && lon == 0.0) {
                      ref
                          .read(geolocatorProvider.notifier)
                          .getCurrentLocation()
                          .then((value) {
                            if (value != null) {
                              _selectSearchResult(
                                LocationDataModel(
                                  latitude: value.latitude,
                                  longitude: value.longitude,
                                ),
                              );
                            }
                          });
                    } else {
                      _selectSearchResult(
                        LocationDataModel(latitude: lat!, longitude: lon!),
                      );
                    }
                  },
                  child: const Icon(
                    Icons.my_location,
                    color: AppColors.secondaryColor,
                  ),
                ),
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
                  hintText: context.tr("search_location"),
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
                      setState(() {});
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
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: AsyncStateHandler(
                      dataList: searchResults,
                    
                      status: searchState.status,
                      onRetry: () {},
                      itemBuilder: (context, index) {
                        final result = searchResults[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity(
                            horizontal: -4.0,
                            vertical: -3.0,
                          ),
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
                ),
            ],
          );
        },
      ),
    );
  }
}
