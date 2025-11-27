import 'package:geolocator/geolocator.dart';
import 'package:push_price_user/models/favourite_data_model.dart';
import 'package:push_price_user/providers/favourite_provider/favourite_provider.dart';

import '../../export_all.dart';
import '../../utils/extension.dart';

class AddNewFavouriteView extends ConsumerStatefulWidget {
  final bool isSignUp;
  final FavouriteModel? data;
  final bool? isScan;
  const AddNewFavouriteView({
    super.key,
    this.data,
    required this.isSignUp,
    this.isScan = false
  });

  @override
  ConsumerState<AddNewFavouriteView> createState() =>
      _AddNewFavouriteViewState();
}

class _AddNewFavouriteViewState extends ConsumerState<AddNewFavouriteView> {
  List<LocationDataModel> myLocation = [];
  List<ProductSelectionDataModel> products = [];

  int selectIndex = -1;
  bool selectTravelMode = false;
  double radius = 0;
  String distanceUnit = "METERS";
  @override
  void initState() {
    Future.microtask(() {
      ref.read(geolocatorProvider.notifier).getAddresses();
      products = widget.data != null ?widget.data!.products : List.from(
        ref.watch(favouriteProvider).products!.where((e) => e.isSelect),
      );
      if(widget.data != null)
      {
      selectTravelMode = widget.data!.travelMode;
      radius = double.tryParse(widget.data!.distanceValue.toString()) ?? 0.0;
      distanceUnit = widget.data!.distanceUnit;

      }
      setState(() {
        
      });
      
    });
    // Future.delayed(Duration(seconds: 3),(){
    //   if(!isSet){
    //   isSet = true;
    // }
    //   setState(() {});
    // });
    
    super.initState();
  }

  void selectAddress(int index) {
    if (myLocation.isNotEmpty) {
      myLocation[index].isSelect = !myLocation[index].isSelect!;
      setState(() {});
    }
  }
  bool isSet = false;

  
  @override
  Widget build(BuildContext context) {
    // if(!isSet){
    //   isSet = true;
    // }
    return CustomScreenTemplate(
      showBottomButton: true,
      customBottomWidget: Consumer(
        builder: (context, ref, child) {
          final isLoad =
              ref.watch(
                favouriteProvider.select(
                  (e) => widget.data != null? e.updateFavouriteApiResponse.status : e.addNewFavouriteApiResponse.status,
                ),
              ) ==
              Status.loading;
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.horizontalPadding,
            ),
            child: CustomButtonWidget(
              isLoad: isLoad,
              title: widget.data != null ? context.tr("save") : context.tr("add_favorite"),
              onPressed: () {
              if(myLocation.isEmpty){
                Helper.showMessage(context, message: context.tr("please_first_add_location"));
                return;
              }
              else if(radius == 0.0){
Helper.showMessage(context, message: context.tr("please_set_a_distance"));
                return;
              }
               List<int> addressIds = [];

                    for (var item in myLocation) {
                      if (item.isSelect!) {
                        addressIds.add(item.addressId!);
                      }
                    }
                    if (addressIds.isEmpty) {
                      Helper.showMessage(
                        context,
                        message: context.tr("please_select_a_location"),
                      );
                      return;
                    }
                    Map<String, dynamic> data = {
                      "product_ids": products.map((e) => e.id).toList(),
                      "address_ids": addressIds,
                      "distance_value": radius,
                      "distance_unit": distanceUnit,
                      "travel_mode": selectTravelMode,
                    };
                  if (widget.data == null || widget.isSignUp) {
                    

                    ref.read(favouriteProvider.notifier).addNewFavourite(data,widget.isSignUp,widget.isScan!);
                  } else {
                    ref.read(favouriteProvider.notifier).updateFavourite(favouriteId: widget.data!.favoriteId, favouriteData: data,);
                  }
                
              },
            ),
          );
        },
      ),
      bottomButtonText:  widget.data != null ? context.tr("save") : context.tr("add_favorite"),

      title:  widget.data != null ? context.tr("edit") : context.tr("add_new_favorite"),
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: AppTheme.horizontalPadding),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.horizontalPadding,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductPriceTitleWidget(product: product);
              },
              separatorBuilder: (context, index) => 5.ph,
              itemCount: products.length,
            ),
          ),
          10.ph,
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.horizontalPadding,
            ),
            child: Row(
              children: [
                Text(context.tr("distance"), style: context.textStyle.displayMedium),
                const Spacer(),
                DropdownButton<String>(
                  value: distanceUnit,
                  items: [
                    DropdownMenuItem(value: "METERS", child: Text(context.tr("meters"))),
                    DropdownMenuItem(value: "KILOMETERS", child: Text(context.tr("kilometers"))),
                  ],
                  onChanged: (value) {
                    if(value == null) return;
                    setState(() {
                      distanceUnit = value;
                      radius = 0;
                    });
                    
                    // Handle unit change if needed
                  },
                  underline: const SizedBox(),
                  style: context.textStyle.bodyMedium,
                ),
              ],
            ),
          ),
          10.ph,
          CustomRangeSlider(
            unit: distanceUnit,
            isSet: isSet,
            initialValue: widget.data != null ?double.tryParse(widget.data!.distanceValue.toString())!: radius,
            onValueChanged: (value) {
              if(!isSet){
                isSet = true;
              }
              setState(() {

                radius = value;
              });
            },
          ),
          20.ph,
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.horizontalPadding,
            ),
            child: Text(context.tr("my_location"), style: context.textStyle.displayMedium),
          ),
          10.ph,
          Consumer(
            builder: (context, ref, child) {
              final data = ref.watch(
                geolocatorProvider.select(
                  (e) => (e.addresses ?? [], e.getAddressesApiResponse),
                ),
              );
              
              if(widget.data != null){
                myLocation = List.from(data.$1.map((e)=>widget.data!.addresses.contains(e)? e.copyWith(isSelect: true): e ));
              }
              else{
                myLocation = data.$1;
              }
              final res = data.$2;
              return res.status == Status.completed && myLocation.isEmpty ?  Padding(
               padding: EdgeInsets.symmetric(
              horizontal: AppTheme.horizontalPadding,
            ),
                child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () async {
                          LocationPermission permission = await Geolocator.checkPermission();
                         
                          if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
                             if(!context.mounted) return;
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(context.tr('location_permission_required')),
                                      SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () async {
                                          LocationPermission newPermission = await Geolocator.requestPermission();
                                          AppRouter.back();
                                          if (newPermission == LocationPermission.whileInUse || newPermission == LocationPermission.always) {
                                            AppRouter.push(AddNewAddressView());
                                          } else {
                                             if(!context.mounted) return;
                                            Helper.showMessage(context, message: context.tr('location_permission_denied'));
                                          }
                                        },
                                        child: Text(context.tr('enable_location')),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            AppRouter.push(AddNewAddressView());
                          }
                        },
                        icon: Icon(Icons.add, color: AppColors.primaryColor),
                        label: Text(
                         context.tr("add_address"),
                          style: context.textStyle.displayMedium!.copyWith(
                            color: AppColors.primaryColor
                          ),
                        ),
                      ),
                    ),
              ) : AsyncStateHandler(
                status: res.status,
                dataList: [""],
                itemBuilder: null,
                onRetry: () =>
                    ref.read(geolocatorProvider.notifier).getAddresses(),
                customSuccessWidget: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => MyLocationTitleWidget(
                    location: myLocation[index],
                    isSelected: myLocation[index].isSelect!,
                    onTap: () {
                      selectAddress(index);
                    },
                  ),
                  separatorBuilder: (context, index) =>
                      Divider(color: Color.fromRGBO(116, 133, 160, 1)),
                  itemCount: myLocation.length,
                ),
              );
            },
          ),

          10.ph,
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.horizontalPadding,
            ),
            child: Text(context.tr("travel_mode"), style: context.textStyle.displayMedium),
          ),
          10.ph,
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.horizontalPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(Assets.travelDiscountIcon, width: 20.r),
                IconButton(
                  visualDensity: VisualDensity(horizontal: -4.0),
                  onPressed: () {
                    selectTravelMode = !selectTravelMode;
                    setState(() {});
                  },
                  icon: Icon(
                    !selectTravelMode
                        ? Icons.check_box_outline_blank
                        : Icons.check_box,
                    color: AppColors.secondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyLocationTitleWidget extends StatelessWidget {
  final LocationDataModel location;
  final VoidCallback onTap;
  final bool isSelected;
  const MyLocationTitleWidget({
    super.key,
    required this.location,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.horizontalPadding,
        vertical: 5.r,
      ),
      child: Row(
        children: [
          SvgPicture.asset(Assets.locationIcon),
          15.pw,

          Expanded(
            child: Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location.label ?? "",
                  style: context.textStyle.headlineMedium,
                  maxLines: 1,
                ),
                Text(
                  location.addressLine1 ?? "",
                  style: context.textStyle.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            visualDensity: VisualDensity(horizontal: -4.0),
            onPressed: onTap,
            icon: Icon(
              !isSelected ? Icons.check_box_outline_blank : Icons.check_box,
              color: AppColors.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductPriceTitleWidget extends StatelessWidget {
  final ProductDataModel product;
  const ProductPriceTitleWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 8.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: Color.fromRGBO(243, 243, 243, 1),
      ),
      child: Row(
        spacing: 10,
        children: [
          Expanded(
            child: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title, style: context.textStyle.bodyMedium),
                Text(
                  "\$${product.price}",
                  style: context.textStyle.bodyMedium!.copyWith(
                    color: AppColors.secondaryColor,
                  ),
                ),
                Text(
                  product.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyle.bodySmall!.copyWith(
                    color: AppColors.primaryTextColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          DisplayNetworkImage(
            imageUrl: product.image,
            width: 57.w,
            height: 70.h,
          ),
        ],
      ),
    );
  }
}

class CustomRangeSlider extends StatefulWidget {
  final ValueChanged<double>? onValueChanged;
  final double initialValue;
  final String unit;
  final bool isSet;
  const CustomRangeSlider({super.key, this.onValueChanged,required this.initialValue, required this.unit, required this.isSet});

  @override
  State<CustomRangeSlider> createState() => _CustomRangeSliderState();
}

class _CustomRangeSliderState extends State<CustomRangeSlider> {
   double _endValue = 0;
   String symbol = 'm';
   int maxValue = 0;

  @override
  void initState() {
    super.initState();
    _updateValues();
    _endValue = widget.initialValue.clamp(0.0, maxValue.toDouble());
   
  }

  void _updateValues() {
    if (widget.unit == "METERS") {
      symbol = 'm';
      _endValue = 0;
      maxValue = 1000;
    } else {
      symbol = 'km';
      _endValue = 0;
      maxValue = 100;
    }
  }

  @override
  void didUpdateWidget(CustomRangeSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    //  _endValue = widget.initialValue.clamp(0.0, maxValue.toDouble());
    if (oldWidget.unit != widget.unit) {
      _updateValues();
       // Use initial value clamped to new range
    }
    if(!widget.isSet){
      _endValue = widget.initialValue.clamp(0.0, maxValue.toDouble());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.r),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.secondaryColor,
              inactiveTrackColor: Colors.teal.shade100,
              thumbColor: AppColors.secondaryColor,
              overlayColor: AppColors.secondaryColor.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: _endValue,
              min: 0,
              max: maxValue.toDouble(),
              onChanged: (value) {
                setState(() => _endValue = value);
                widget.onValueChanged?.call(value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "0$symbol",
                  style: context.textStyle.bodyMedium!.copyWith(
                    color: AppColors.secondaryColor,
                  ),
                ),
                Text(
                  "${_endValue.toInt()}$symbol",
                  style: context.textStyle.bodyMedium!.copyWith(
                    color: AppColors.secondaryColor,
                  ),
                ),
                Text(
                  "$maxValue$symbol",
                  style: context.textStyle.bodyMedium!.copyWith(
                    color: AppColors.secondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
