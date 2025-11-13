import 'package:push_price_user/providers/favourite_provider/favourite_provider.dart';

import '../../export_all.dart';
import '../../utils/extension.dart';

class AddNewFavouriteView extends ConsumerStatefulWidget {
  final bool isSignUp;
  final bool? isEdit;
  const AddNewFavouriteView({
    super.key,
    this.isEdit = false,
    required this.isSignUp,
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
  @override
  void initState() {
    Future.microtask(() {
      ref.read(geolocatorProvider.notifier).getAddresses();
      products = List.from(
        ref.watch(favouriteProvider).products!.where((e) => e.isSelect),
      );
      setState(() {});
    });
    super.initState();
  }

  void selectAddress(int index) {
    if (myLocation.isNotEmpty) {
      myLocation[index].isSelect = !myLocation[index].isSelect!;
      setState(() {});
    }
  }

  num radius = 0;
  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(
      showBottomButton: true,
      customBottomWidget: Consumer(
        builder: (context, ref, child) {
          final isLoad =
              ref.watch(
                favouriteProvider.select(
                  (e) => e.addNewFavouriteApiResponse.status,
                ),
              ) ==
              Status.loading;
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.horizontalPadding,
            ),
            child: CustomButtonWidget(
              isLoad: isLoad,
              title: widget.isEdit! ? "save" : "add favorite",
              onPressed: () {
                if (widget.isSignUp) {
                  AppRouter.pushAndRemoveUntil(NavigationView());
                } else {
                  if (!widget.isEdit!) {
                    List<int> addressIds = [];

                    for (var item in myLocation) {
                      if (item.isSelect!) {
                        addressIds.add(item.addressId!);
                      }
                    }
                    if (addressIds.isEmpty) {
                      Helper.showMessage(
                        context,
                        message: "Please select a location",
                      );
                      return;
                    }

                    ref.read(favouriteProvider.notifier).addNewFavourite({
                      "product_ids": products.map((e) => e.id).toList(),
                      "address_ids": addressIds,
                      "distance_value": radius,
                      "distance_unit": "METERS",
                      "travel_mode": selectTravelMode,
                    });
                  } else {
                    AppRouter.back();
                  }
                }
              },
            ),
          );
        },
      ),
      bottomButtonText: widget.isEdit! ? "save" : "add favorite",

      title: widget.isEdit! ? "Edit" : "Add New Favorite",
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
            child: Text("Distance", style: context.textStyle.displayMedium),
          ),
          10.ph,
          CustomRangeSlider(
            onValueChanged: (value) {
              radius = value;
            },
          ),
          20.ph,
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.horizontalPadding,
            ),
            child: Text("My Location", style: context.textStyle.displayMedium),
          ),
          10.ph,
          Consumer(
            builder: (context, ref, child) {
              final data = ref.watch(
                geolocatorProvider.select(
                  (e) => (e.addresses ?? [], e.getAddressesApiResponse),
                ),
              );
              myLocation = data.$1;
              final res = data.$2;
              return AsyncStateHandler(
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
            child: Text("Travel Mode", style: context.textStyle.displayMedium),
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
                  product.category?.title ?? "",
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
  const CustomRangeSlider({super.key, this.onValueChanged});

  @override
  State<CustomRangeSlider> createState() => _CustomRangeSliderState();
}

class _CustomRangeSliderState extends State<CustomRangeSlider> {
  double _endValue = 17;

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
              max: 20,
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
                  "0m",
                  style: context.textStyle.bodyMedium!.copyWith(
                    color: AppColors.secondaryColor,
                  ),
                ),
                Text(
                  "${_endValue.toInt()}m",
                  style: context.textStyle.bodyMedium!.copyWith(
                    color: AppColors.secondaryColor,
                  ),
                ),
                Text(
                  "20m",
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
