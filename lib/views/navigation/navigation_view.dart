
import 'package:push_price_user/utils/extension.dart';

import '../../export_all.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({super.key});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
 

  int selectIndex = 0;
  // bool _isBottomBarVisible = true;

  final ScrollController scrollController = ScrollController();
  final ScrollController drawerScrollController = ScrollController();
  late final List<BottomDataModel> bottomNavItems ;

  @override
  void initState() {
    super.initState();

    // scrollController.addListener(() {
    //   final direction = scrollController.position.userScrollDirection;
    //   if (direction == ScrollDirection.reverse && _isBottomBarVisible) {
    //     setState(() => _isBottomBarVisible = false);
    //   } else if (direction == ScrollDirection.forward && !_isBottomBarVisible) {
    //     setState(() => _isBottomBarVisible = true);
    //   }
    // });
    bottomNavItems = [
    BottomDataModel(title: "Home", icon: Assets.home, child: HomeView(scrollController: scrollController ,)),
    BottomDataModel(title: "Explore", icon: Assets.explore, child: ExploreView(scrollController: scrollController,)),
    BottomDataModel(title: "Favourite", icon: Assets.heart, child: FavouriteView(scrollController: scrollController,)),
    BottomDataModel(title: "Profile", icon: Assets.profile, child: ProfileView()),
  ];
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color(0xFFF2F7FA),
          child: Padding(
            padding: EdgeInsets.all(AppTheme.horizontalPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Logout', style: context.textStyle.displayMedium!.copyWith(fontSize: 18.sp)),
                10.ph,
                Text(
                  'Are you sure you want to logout?',
                  textAlign: TextAlign.center,
                  style: context.textStyle.bodyMedium!.copyWith(color: Colors.grey),
                ),
                30.ph,
                Row(
                  spacing: 20,
                  children: [
                    Expanded(
                      child: CustomOutlineButtonWidget(
                        title: "cancel",
                        onPressed: () => AppRouter.back(),
                      ),
                    ),
                    Expanded(
                      child: CustomButtonWidget(
                        title: "logout",
                        onPressed: () => AppRouter.pushAndRemoveUntil(LoginView()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

 

  @override
  Widget build(BuildContext context) {
     final List<MenuDataModel> menuData = [
    MenuDataModel(title: "My Favorites", icon: Assets.menuFavouritIcon, onTap: () {
      AppRouter.back();
      setState(() {
        selectIndex = 2;
      });
      
    }),
    MenuDataModel(title: "My Orders", icon: Assets.menuMyorderIcon, onTap: () => AppRouter.push(MyOrderView())),
    MenuDataModel(title: "My Locations", icon: Assets.menuLocationIcon, onTap: () => AppRouter.push(MyLocationView())),
    MenuDataModel(title: "Subscription & Savings", icon: Assets.menuDollarSquareIcon, onTap: () => AppRouter.push(MySubscriptionPlanView())),
    MenuDataModel(title: "Vouchers", icon: Assets.menuVoucherIcon, onTap: () => AppRouter.push(VoucherView())),
    MenuDataModel(title: "Payment Methods", icon: Assets.menuPaymentIcon, onTap: () => AppRouter.push(MyPaymentMethodView())),
    MenuDataModel(title: "Settings", icon: Assets.menuSettingIcon, onTap: () => AppRouter.push(SettingView())),
    MenuDataModel(title: "Help & Feedback", icon: Assets.menuHelpIcon, onTap: () => AppRouter.push(HelpFeedbackView())),
  ];
    return Scaffold(
      key: AppRouter.scaffoldkey,
      drawerEnableOpenDragGesture: false,
      extendBody: true,
      drawer: SafeArea(
        bottom: false,
        top: true,
        child: Drawer(
          width: context.screenwidth * 0.8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(right: Radius.circular(30.r)),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                right: 15.r,
                top: 15.r,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 30.r,
                    width: 30.r,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, size: 18.r, color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 50.r,
                child: GestureDetector(
                  onTap: () => showLogoutDialog(context),
                  child: Container(
                    padding: EdgeInsets.only(left: 10.r),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.horizontal(right: Radius.circular(50.r)),
                    ),
                    height: 45.h,
                    width: context.screenwidth * 0.48,
                    child: Row(
                      spacing: 20,
                      children: [
                        const Icon(Icons.exit_to_app, color: Colors.white),
                        Text(
                          "Logout",
                          style: context.textStyle.headlineMedium!.copyWith(
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  50.ph,
                  Center(
                    child: Column(
                      spacing: 7,
                      children: [
                        UserProfileWidget(radius: 45.r, imageUrl: Assets.userImage),
                        5.ph,
                        Text("John Smit", style: context.textStyle.headlineMedium!.copyWith(fontSize: 18.sp)),
                        Text("Johnsmith@domain.com", style: context.textStyle.bodyMedium),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: context.screenheight * 0.50,
                    child: Scrollbar(
                      trackVisibility: true,
                      thumbVisibility: true,
                      controller: drawerScrollController,
                      child: ListView(
                        primary: false,
                        controller: drawerScrollController,
                        padding: EdgeInsets.all(20.r),
                        children: List.generate(menuData.length, (index) {
                          final menu = menuData[index];
                          return ListTile(
                            onTap: menu.onTap,
                            visualDensity: VisualDensity(
                              vertical: -2.0
                            ),
                            leading: SvgPicture.asset(menu.icon),
                            title: Text(menu.title),
                            titleTextStyle: context.textStyle.displayMedium!.copyWith(fontSize: 16.sp),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: bottomNavItems[selectIndex].child,
      bottomNavigationBar: CustomBottomNavBarWidget(
          items: bottomNavItems,
          currentIndex: selectIndex,
          onTap: (index) {
            setState(() => selectIndex = index);
          },
        ),
      // bottomNavigationBar: AnimatedSlide(
      //   offset: _isBottomBarVisible ? Offset.zero : const Offset(0, 1),
      //   duration: const Duration(milliseconds: 300),
      //   child: CustomBottomNavBarWidget(
      //     items: bottomNavItems,
      //     currentIndex: selectIndex,
      //     onTap: (index) {
      //       setState(() => selectIndex = index);
      //     },
      //   ),
      // ),
    );
  }
}
