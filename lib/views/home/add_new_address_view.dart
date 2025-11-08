import '../../export_all.dart';

class AddNewAddressView extends StatefulWidget {
  const AddNewAddressView({super.key});

  @override
  State<AddNewAddressView> createState() => _AddNewAddressViewState();
}

class _AddNewAddressViewState extends State<AddNewAddressView> {
  final TextEditingController searchTextController = TextEditingController();
  final TextEditingController labelController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  double? latitude;
  double? longitude;

  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(
      title: "Add New Address",
      child: Padding(
        padding: EdgeInsets.all(AppTheme.horizontalPadding),
        child: Consumer(
          builder: (context, ref, child) {
            final locationData = ref.watch(geolocatorProvider.select((e) => e.locationData));

            // Update latitude and longitude when location data changes
            if (locationData != null && latitude == null && longitude == null) {
              latitude = locationData.latitude;
              longitude = locationData.longitude;
            }

            return Column(
              spacing: 16,
              children: [
                TextField(
                  controller: labelController,
                  decoration: InputDecoration(
                    hintText: "Label (e.g., Home, Work)",
                    border: OutlineInputBorder(),
                  ),
                ),
                TextField(
                  controller: addressLine1Controller,
                  decoration: InputDecoration(
                    hintText: "Address Line 1",
                    border: OutlineInputBorder(),
                  ),
                ),
                TextField(
                  controller: addressLine2Controller,
                  decoration: InputDecoration(
                    hintText: "Address Line 2 (Optional)",
                    border: OutlineInputBorder(),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: cityController,
                        decoration: InputDecoration(
                          hintText: "City",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: stateController,
                        decoration: InputDecoration(
                          hintText: "State",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: postalCodeController,
                        decoration: InputDecoration(
                          hintText: "Postal Code",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: countryController,
                        decoration: InputDecoration(
                          hintText: "Country",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     ref.read(geolocatorProvider.notifier).getCurrentLocation();
                //     // Location will be updated via the Consumer watching locationData
                //   },
                //   child: Text("Use Current Location"),
                // ),
                Consumer(
                  builder: (context, ref, child) {
                    final addAddressState = ref.watch(geolocatorProvider.select((e) => e.addAddressApiResponse));
                    return CustomButtonWidget(
                      isLoad: addAddressState.status == Status.loading,
                      onPressed: addAddressState.status == Status.loading ? null : () {
                        if (labelController.text.isEmpty ||
                            addressLine1Controller.text.isEmpty ||
                            cityController.text.isEmpty ||
                            stateController.text.isEmpty ||
                            postalCodeController.text.isEmpty ||
                            countryController.text.isEmpty ||
                            latitude == null ||
                            longitude == null) {
                          Helper.showMessage(context, message: "Please fill all required fields and set location");
                          return;
                        }

                        final addressData = {
                          'label': labelController.text,
                          'address_line1': addressLine1Controller.text,
                          'address_line2': addressLine2Controller.text.isNotEmpty ? addressLine2Controller.text : null,
                          'city': cityController.text,
                          'state': stateController.text,
                          'postal_code': postalCodeController.text,
                          'country': countryController.text,
                          'latitude': latitude,
                          'longitude': longitude,
                        };

                        ref.read(geolocatorProvider.notifier).addAddress(addressData);
                      },
                      title: "Add Address"
                      );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
