import 'package:push_price_user/utils/extension.dart';
import 'package:push_price_user/views/home/all_store_view.dart';

import '../../export_all.dart';

class HomeView extends StatefulWidget {
  final ScrollController scrollController;
  const HomeView({super.key, required this.scrollController});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  void showLocationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      backgroundColor: Color.fromRGBO(242, 248, 254, 1),
      builder: (context) {
        int selectedIndex = 0;
        List<String> addresses = List.generate(
          4,
          (index) => 'Lorem Ipsum Street',
        );

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding:  EdgeInsets.symmetric( vertical: 24, horizontal: AppTheme.horizontalPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Close button & Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      24.pw, // Placeholder for alignment
                      Text('Location', style: context.textStyle.bodyMedium!.copyWith(
                        fontSize: 16.sp
                      )),
                      InkWell(
                        onTap: () => AppRouter.back(),
                        child: Container(
                          height: 30.r,
                          width: 30.r,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: 0.1,
                                ), // subtle shadow
                                blurRadius: 6, // smooth blur
                                spreadRadius: 1,
                                offset: Offset(0, 2), // slight downward shadow
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.close,
                            size: 18.r,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  16.ph,

                  // Use My Current Location
                  ListTile(
                    leading: Transform.rotate(
                      angle: 45,
                      child: Icon(Icons.navigation, color: Colors.teal),
                    ),
                    visualDensity: VisualDensity(
                      horizontal: -4.0,
                      vertical: -4.0
                    ),
                    contentPadding: EdgeInsets.zero,
                    title: Text('Use My Current Location'),
                    onTap: () {
                      // Handle location logic
                    },
                  ),
                
                  // Address list (Radio buttons)
                  ...List.generate(addresses.length, (index) {
                    return RadioListTile<int>(
                      value: index,
                      contentPadding: EdgeInsets.zero,
                      groupValue: selectedIndex,
                      splashRadius: 0.0,
                      onChanged: (value) =>
                          setState(() => selectedIndex = value!),
                      activeColor: AppColors.secondaryColor,
                      
                      title: Text(addresses[index]),
                    );
                  }),

                  

                  // Add New Address
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        // Handle adding new address
                      },
                      icon: Icon(Icons.add, color: AppColors.secondaryColor),
                      label: Text(
                        "Add New Address",
                        style: context.textStyle.displayMedium!.copyWith(
                          color: AppColors.primaryColor
                        ),
                      ),
                    ),
                  ),
                  20.ph
                ],
              ),
            );
          },
        );
      },
    );
  }

  bool travelMode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        height: context.screenheight * 0.2,
        title: "Home",
        children: [
          CustomSearchBarWidget(
            hintText: "Hinted search text",
            suffixIcon: SvgPicture.asset(Assets.filterIcon),
            onTapOutside: (c){
               FocusScope.of(context).unfocus();
            },
          ),
          Row(
            children: [
              SvgPicture.asset(Assets.locationIcon),
              10.pw,

              Expanded(
                child: InkWell(
                  onTap: () {
                    showLocationBottomSheet(context);
                  },
                  child: Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Home", style: context.textStyle.headlineMedium),
                      Text(
                        "ABC, Street Lorem Ipsum",
                        style: context.textStyle.titleSmall,
                      ),
                    ],
                  ),
                ),
              ),

              Text("Travel Mode", style: context.textStyle.displayMedium),
              10.pw,
              CustomSwitchWidget(
               scale: 1.0,
                value: travelMode,
                onChanged: (val) {
                  travelMode = val;
                  setState(() {});
                },
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(AppTheme.horizontalPadding),
        controller: widget.scrollController,
        children: [
          SpecialOfferBannerSection(),
          10.ph,
          CategoriesSection(),
          10.ph,
          PopularStoresSection(),
          10.ph,
          NearbyStoresSection(),
        ],
      ),
    );
  }
}

class PopularStoresSection extends StatelessWidget {
  const PopularStoresSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<StoreDataModel> stores = List.generate(
      10,
      (index) => StoreDataModel(
        title: "Abc Store",
        address: "abc street",
        rating: 4.5,
        icon: Assets.store,
      ),
    );
    return SizedBox(
      height: context.screenheight * 0.20,
      child: Column(
        spacing: 10,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Popular Stores", style: context.textStyle.displayMedium),
              TextButton(
                style: ButtonStyle(
                  padding: WidgetStatePropertyAll(EdgeInsets.zero),
                  visualDensity: VisualDensity(
                    vertical: -4.0,
                    horizontal: -4.0,
                  ),
                ),
                onPressed: () {
                  AppRouter.push(AllStoreView(title: "Popular Stores"));
                },
                child: Text(
                  "See All",
                  style: context.textStyle.bodySmall!.copyWith(
                    color: context.colors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final store = stores[index];
                return StoreCardWidget(data: store);
              },
              separatorBuilder: (context, index) => 10.pw,
              itemCount: stores.length,
            ),
          ),
        ],
      ),
    );
  }
}

class StoreCardWidget extends StatelessWidget {
  final StoreDataModel data;
  const StoreCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        AppRouter.push(StoreView());
      },
      child: Container(
        height: double.infinity,
        // width: 94.w,
        padding: EdgeInsets.symmetric(horizontal: 20.r),
        decoration: BoxDecoration(
          color: Color.fromRGBO(243, 243, 243, 1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(data.icon, width: 50.r, height: 50.r),
            Text(data.title, maxLines: 1, style: context.textStyle.bodySmall),
            Text(data.address, style: context.textStyle.titleSmall, maxLines: 1),
            Row(
              
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Color.fromRGBO(255, 144, 28, 1), size: 22.r,),
                Text(data.rating.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NearbyStoresSection extends StatelessWidget {
  const NearbyStoresSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<StoreDataModel> stores = List.generate(
      10,
      (index) => StoreDataModel(
        title: "Abc Store",
        address: "abc street",
        rating: 4.5,
        icon: Assets.store,
      ),
    );
    return SizedBox(
      height: context.screenheight * 0.20,
      child: Column(
        spacing: 10,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Nearby Stores", style: context.textStyle.displayMedium),
              TextButton(
                style: ButtonStyle(
                  padding: WidgetStatePropertyAll(EdgeInsets.zero),
                  visualDensity: VisualDensity(
                    vertical: -4.0,
                    horizontal: -4.0,
                  ),
                ),
                onPressed: () {
                  AppRouter.push(AllStoreView(title: "Nearby Stores"));
                },
                child: Text(
                  "See All",
                  style: context.textStyle.bodySmall!.copyWith(
                    color: context.colors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final store = stores[index];
                return StoreCardWidget(data: store);
              },
              separatorBuilder: (context, index) => 10.pw,
              itemCount: stores.length,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CategoryDataModel> categories = [
      CategoryDataModel(title: "Fruits", icon: Assets.fruits),
      CategoryDataModel(title: "Vegtables", icon: Assets.vegetable),
      CategoryDataModel(title: "Meat", icon: Assets.meat),
      CategoryDataModel(title: "Sea Food", icon: Assets.seaFood),
      CategoryDataModel(title: "Groceries", icon: Assets.grocery),
    ];
    return SizedBox(
      height: context.screenheight * 0.17,
      child: Column(
        spacing: 10,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Categories", style: context.textStyle.displayMedium),
              TextButton(
                style: ButtonStyle(
                  padding: WidgetStatePropertyAll(EdgeInsets.zero),
                  visualDensity: VisualDensity(
                    vertical: -4.0,
                    horizontal: -4.0,
                  ),
                ),
                onPressed: () {
                  AppRouter.push(AllCategoryView());
                },
                child: Text(
                  "See All",
                  style: context.textStyle.bodySmall!.copyWith(
                    color: context.colors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final category = categories[index];
                return SizedBox(
                  width: context.screenwidth * 0.17,
                  child: Column(
                    spacing: 10,
                    children: [
                      CircleAvatar(
                        radius: 25.r,
                        backgroundColor: Color.fromRGBO(238, 247, 254, 1),
                        child: Padding(
                          padding: EdgeInsets.all(5.r),
                          child: Image.asset(category.icon),
                        ),
                      ),
                      Text(
                        category.title,
                        style: context.textStyle.bodyMedium,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => 5.pw,
              itemCount: categories.length,
            ),
          ),
        ],
      ),
    );
  }
}

class SpecialOfferBannerSection extends StatelessWidget {
  const SpecialOfferBannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenheight * 0.20,
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Special Offers", style: context.textStyle.displayMedium),
          Expanded(
            child: ClipRRect(
              child: Image.asset(
                Assets.specialDiscountBanner,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
