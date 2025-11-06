import 'dart:async';

import '../../export_all.dart';
import '../../utils/extension.dart';

class HomeView extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  const HomeView({super.key, required this.scrollController});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView>  {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(authProvider.notifier).getUser();
      ref.read(homeProvider.notifier).getCategories();
      ref.read(homeProvider.notifier).getStores(limit: 10, skip: 0);
      ref.read(homeProvider.notifier).getNearbyStores(limit: 10, skip: 0);
      ref.read(geolocatorProvider.notifier).getCurrentLocation();

    });
  }




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
                     ref.read(geolocatorProvider.notifier).getCurrentLocation();
                    },
                  ),
                
                  // Address list (Radio buttons)
                  RadioGroup<int>(
                    groupValue: selectedIndex,
                    onChanged: (value) => setState(() => selectedIndex = value!),
                    child: Column(
                      children: List.generate(addresses.length, (index) {
                        return Radio<int>(
                          value: index,
                          activeColor: AppColors.secondaryColor,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
                        );
                      }),
                    ),
                  ),

                  

                  // Add New Address
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        // Handle adding new address
                        AppRouter.push(AddNewAddressView());
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

  // bool travelMode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        height: context.screenheight * 0.21,
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

              Consumer(
                builder: (context, ref, child) {
                  final String address = ref.watch(geolocatorProvider.select((e)=>e.locationData?.address ?? ""));
               
                  return Expanded(
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
                            address,
                            style: context.textStyle.titleSmall,
                          ),
                        ],
                      ),
                    ),
                  );
                }
              ),

              Text("Travel Mode", style: context.textStyle.displayMedium),
              10.pw,
              Consumer(
                builder: (context,ref, child) {
                     final bool isTravelMode = ref.watch(authProvider.select((e)=>e.userData?.isTravelMode ?? false));
                  return CustomSwitchWidget(
                   scale: 1.0,
                    value: isTravelMode ,
                    onChanged: (val) {
                      
                      ref.read(geolocatorProvider.notifier).toggleTravelMode(val);
                      
                    },
                  );
                }
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(AppTheme.horizontalPadding).copyWith(
          bottom: 100.r
        ),
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
    return Consumer(
      builder: (context, ref, child) {
        final homeState = ref.watch(homeProvider.select((e) => (e.getStoresApiResponse, e.stores)));
        final stores = homeState.$2 ?? [];
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
                child: AsyncStateHandler(
                  status: homeState.$1.status,
                  dataList: stores,
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final store = stores[index];
                    return StoreCardWidget(data: store);
                  },
                  onRetry: () {
                    ref.read(homeProvider.notifier).getStores(limit: 10, skip: 0);
                  },
                ),
              ),
            ],
          ),
        );
      },
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
        width: 94.w,
        padding: EdgeInsets.symmetric(horizontal: 20.r),
        decoration: BoxDecoration(
          color: Color.fromRGBO(243, 243, 243, 1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(Assets.store, width: 50.r, height: 50.r),
            Text(data.title!, maxLines: 1, style: context.textStyle.bodySmall, textAlign: TextAlign.center,),
            Text(data.address!, style: context.textStyle.titleSmall, maxLines: 1, textAlign: TextAlign.center,),
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
    return Consumer(
      builder: (context, ref, child) {
        final homeState = ref.watch(homeProvider.select((e) => (e.getNearbyStoresApiResponse, e.nearbyStores)));
        final stores = homeState.$2 ?? [];
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
                child: AsyncStateHandler(
                  status: homeState.$1.status,
                  dataList: stores,
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final store = stores[index];
                    return StoreCardWidget(data: store);
                  },
                  onRetry: () {
                    ref.read(homeProvider.notifier).getNearbyStores(limit: 10, skip: 0);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});


  @override
  Widget build(BuildContext context) {
    

    return Consumer(
      builder: (context, ref, child) {
        final homeState = ref.watch(homeProvider.select((e)=>(e.getCategoriesApiResponse, e.categories)));
        final categories = homeState.$2 ?? [];
        return SizedBox(
          height: context.screenheight * 0.17,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
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
                child: AsyncStateHandler(
                  status: homeState.$1.status,
                  dataList: categories,
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return SizedBox(
                      width: context.screenwidth * 0.17,
                      child: GestureDetector(
                        onTap: () {
                          AppRouter.push(CategoryProductView(title: category.title));
                        },
                        child: Column(
                          spacing: 10,
                          children: [
                            CircleAvatar(
                              radius: 25.r,
                              backgroundColor: Color.fromRGBO(238, 247, 254, 1),
                              child: Padding(
                                padding: EdgeInsets.all(5.r),
                                child: DisplayNetworkImage(imageUrl: category.icon), // Fallback icon
                              ),
                            ),
                            Text(
                              category.title,
                              style: context.textStyle.bodyMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  onRetry: () {
                    ref.read(homeProvider.notifier).getCategories(chainId: null);
                  },
                ),
              ),
            ],
          ),
        );
      }
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
            child:AdSliderWidget(images: ["", "", "", "", ""]),
            //  ClipRRect(
            //   child: Image.asset(
            //     Assets.specialDiscountBanner,
            //     fit: BoxFit.contain,
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}
class AdSliderWidget extends StatefulWidget {
  final List<String> images;
  const AdSliderWidget({super.key, required this.images});

  @override
  State<AdSliderWidget> createState() => _AdSliderWidgetState();
}

class _AdSliderWidgetState extends State<AdSliderWidget> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Automatically transition images every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), _onTimerTick);
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onTimerTick(Timer timer) {
    if (widget.images.isNotEmpty) {
      if (_currentIndex < widget.images.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }

      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.images.isNotEmpty
        ? Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.images.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    // return DisplayNetworkImage(
                    //     imageUrl: widget.images[index])
                    //     ;
                    return Image.asset(
                            Assets.specialDiscountBanner,
                            fit: BoxFit.cover,
                      );
                  },
                ),
              ),
            ),
            7.ph,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PagerDot(
                  length: widget.images.length,
                  currentIndex: _currentIndex,
                  isCircle: true,
                )
              ],
            ),
          ],
        )
        : const SizedBox.shrink();
  }
}