import '../../export_all.dart';
import '../../utils/extension.dart';

class StoreView extends ConsumerStatefulWidget {
  final StoreDataModel storeData;
  final int? productId;
  const StoreView({super.key, required this.storeData, this.productId});

  @override
  ConsumerState<StoreView> createState() => _StoreViewState();
}

class _StoreViewState extends ConsumerState<StoreView> {
  int selectIndex = -1;
  int count = 0;
  num price = 0;
  final List<String> listType = [
    "best_by_products",
    "instant_sales",
    "weighted_items",
    "promotional_products",
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(()async {
      fetchProducts(0);
      loadCartData();
      
    });
  }

  void loadCartData() {
    ref.read(orderProvider.notifier).voucherApiUnset();
    final List<ProductPurchasingDataModel> cartList = ref.read(homeProvider.select((e) => e.cartList));
    setState(() {
      count = cartList.fold(0, (sum, item) => sum + item.selectQuantity);
      price = cartList.fold(0.0, (sum, item) => sum + (item.discountedPrice! * item.selectQuantity));
    });
  }

  void fetchProducts(int skip) {
    ref.read(homeProvider.notifier).getStoreProducts(
      storeId: widget.storeData.storeId,
      skip: skip,
      limit: 10,
      type: selectIndex == -1? null : Helper.setType(listType[selectIndex])
    );
  }

  void addQuantity(ProductPurchasingDataModel product, int index) {
    ref.read(homeProvider.notifier).addQuantity(product, index);
    loadCartData();
  }

  void removeQuantity(ProductPurchasingDataModel product) {
    ref.read(homeProvider.notifier).removeQuantity(product);
    loadCartData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomSheet: count >0? Padding(padding: EdgeInsets.all(AppTheme.horizontalPadding), child: CustomButtonWidget(title: "", onPressed: (){
        AppRouter.push(CartView(
          storeId: widget.storeData.storeId,
        ), fun: (){
          loadCartData();
        });
      }, child: Padding(
        padding: const EdgeInsets.all(8.0),
        
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 20.r,
              height: 20.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 0.8
                )
              ),
              alignment: Alignment.center,
              child: Text("$count", style: context.textStyle.titleSmall!.copyWith(
                color: Colors.white
              ),),
            ),
            Text("View Your Cart", style: context.textStyle.bodyMedium!.copyWith(
              color: Colors.white
            ),),
            Text("\$$price", style: context.textStyle.bodySmall!.copyWith(
              color: Colors.white
            ),),
          ],
        ),
      ),),) : null,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(context.screenheight * 0.10),
        child:
            // Container(
            //   decoration: BoxDecoration(
            //     color: AppColors.primaryAppBarColor,
            //     borderRadius: BorderRadius.vertical(
            //       bottom: Radius.circular(30.r)
            //     )
            //   ),
            // )
            AppBar(
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30.r),
                ),
              ),
              backgroundColor: AppColors.primaryAppBarColor,
              leadingWidth: context.screenwidth * 0.38,
              leading: Row(
                
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppTheme.horizontalPadding,
                      vertical: 10.r,
                    ),
                    child: CustomBackWidget(),
                  ),
                ],
              ),
              centerTitle: true,
              title: GestureDetector(
                onTap: (){
                  AppRouter.push(StoreDetailView());
                },
                child: Text(widget.storeData.storeName, style: context.textStyle.displayMedium)),
              actions: [
                Consumer(
                  builder: (context, ref, child) {
                    final String profileImage = ref.watch(authProvider.select((e)=>e.userData?.profileImage ?? ""));
                    return UserProfileWidget(
                      radius: 18.r,
                      imageUrl: profileImage,
                      borderWidth: 2,
                    );
                  }
                ),
                20.pw,
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(context.screenheight),
                child: Consumer(
                  builder: (context, ref, child) {
                    final String address = ref.watch(geolocatorProvider.select((e)=>e.locationData?.addressLine1 ?? ""));
                    return address != ""? Padding(
                      padding: EdgeInsets.only(bottom: 20.r),
                      child: Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(Assets.locationIcon),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: context.screenwidth * 0.65
                            ),
                            child: Text(
                              address,
                              style: context.textStyle.bodyMedium,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ) : SizedBox.shrink();
                  }
                ),
              ),
            ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectChipWidget(
            items: listType,
            selectedIndex: selectIndex,
            onSelected: (index) {
              setState(() {

                selectIndex = selectIndex==index? -1: index ;
              });
              fetchProducts(0);

            },
          ),
          if(selectIndex > -1)...[
            5.ph,
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.horizontalPadding,
            ),
            child: Text(
              context.tr(listType[selectIndex]),
              style: context.textStyle.displayMedium,
            ),
          ),
          ],
          
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final homeState = ref.watch(homeProvider.select((e) => (e.getStoreProductsApiResponse, e.products)));
                final products = homeState.$2 ?? [];
                return AsyncStateHandler(
                  status: homeState.$1.status,
                  dataList: products,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () {
                        AppRouter.push(ProductDetailView(
                          quatity: product.selectQuantity,
                          product: product,
                          discount: product.discount,
                          storeId: widget.storeData.storeId,
                        ));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.r,
                          horizontal: 20.r,
                        ),
                        decoration:widget.productId != null ?AppTheme.productBoxDecoration.copyWith(
                          color: widget.productId== product.id? AppColors.secondaryColor.withValues(alpha: 0.1) : null
                        ) : AppTheme.productBoxDecoration,
                        child: Stack(
                          children: [
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: product.selectQuantity > 0
                                  ? Container(
                                      padding: EdgeInsets.all(5.r),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(30.r),
                                          right: Radius.circular(30.r),
                                        ),
                                        border: Border.all(
                                          width: 1,
                                          color: AppColors.borderColor,
                                        ),
                                      ),
                                      child: Row(
                                        spacing: 10,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              removeQuantity(product);
                                            },
                                            child: product.selectQuantity == 1
                                                ? SvgPicture.asset(Assets.deleteIcon)
                                                : Container(
                                                    width: 17.r,
                                                    height: 17.r,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        color: AppColors.secondaryColor,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "-",
                                                      style: TextStyle(
                                                        color: AppColors.secondaryColor,
                                                        fontSize: 12.sp,
                                                        height: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                          Text("${product.selectQuantity}", style: context.textStyle.displayMedium),
                                          GestureDetector(
                                            onTap: () {
                                              addQuantity(product, index);
                                            },
                                            child: SvgPicture.asset(Assets.addCircleIcon),
                                          ),
                                        ],
                                      ),
                                    )
                                  : IconButton(
                                      padding: EdgeInsets.zero,
                                      visualDensity: VisualDensity(
                                        horizontal: -4.0,
                                        vertical: -4.0,
                                      ),
                                      onPressed: () {
                                        addQuantity(product, index);
                                      },
                                      icon: SvgPicture.asset(Assets.addCircleIcon),
                                    ),
                            ),
                            Row(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Image.asset(Assets.groceryBag, width: 57.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "${product.title} ",
                                              style: context.textStyle.displayMedium,
                                            ),
                                            TextSpan(
                                              text: " ${product.discount}% Off",
                                              style: context.textStyle.titleSmall!.copyWith(
                                                color: AppColors.secondaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      8.ph,
                                      Text.rich(
                                        textAlign: TextAlign.end,
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "\$${product.discountedPrice} ",
                                              style: context.textStyle.displayMedium!.copyWith(
                                                color: AppColors.secondaryColor,
                                              ),
                                            ),
                                            TextSpan(
                                              text: "\$${product.price}",
                                              style: context.textStyle.displayMedium!.copyWith(
                                                decoration: TextDecoration.lineThrough,
                                                color: Color.fromRGBO(91, 91, 91, 1),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      8.ph,
                                      Text(
                                        Helper.getTypeTitle(product.type!)== "Best By Products"
                                            ? "Best By: ${Helper.selectDateFormat(product.bestByDate)}"
                                            : product.description,
                                        style: context.textStyle.bodySmall!.copyWith(
                                          color: AppColors.primaryTextColor.withValues(alpha: 0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  onRetry: () {
                    fetchProducts(0);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
