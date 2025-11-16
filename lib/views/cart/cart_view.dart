import '../../export_all.dart';
import '../../utils/extension.dart';

class CartView extends ConsumerStatefulWidget {
  final int? count;
  final int storeId;
  const CartView({super.key, this.count, required this.storeId});

  @override
  ConsumerState<CartView> createState() => _CartViewState();
}

class _CartViewState extends ConsumerState<CartView> {

  void addQuantity(ProductPurchasingDataModel product) {
    ref.read(homeProvider.notifier).addQuantity(product);
  }

  void removeQuantity(ProductPurchasingDataModel product) {
    ref.read(homeProvider.notifier).removeQuantity(product);
  }


  @override
  void initState() {
    super.initState();
    Future.microtask((){
      });
  }
  void fetchProducts(){
    ref.read(homeProvider.notifier).getPromotionalProducts(storeId: widget.storeId, skip: 0, limit: 10);
    
  }
  @override
  Widget build(BuildContext context) {
    final cartList = ref.watch(homeProvider.select((e) => e.cartList));
    final voucherRes = ref.watch(orderProvider.select((e)=>e.validateVoucherApiResponse));

    final itemTotal = cartList.fold(
      0.0,
      (sum, item) => sum + item.discountedPrice! * item.selectQuantity,
    );
    final total = voucherRes.status == Status.completed && voucherRes.data != null ? voucherRes.data!.finalAmount : itemTotal ;
    return CustomScreenTemplate(
      showBottomButton: total > 0.0,
      customBottomWidget: Consumer(
        builder: (context, ref, child) {
          final isLoad =
              ref.watch(
                orderProvider.select((e) => e.placeOrderApiResponse.status),
              ) ==
              Status.loading;
          
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.horizontalPadding,
            ),
            child: CustomButtonWidget(
              isLoad: isLoad,
              title: "place order",
              onPressed: () {
                
                final cartItems = ref.read(homeProvider.select((e)=>e.cartList));
        
                   Map<String, dynamic> data = {
                  "items": List.generate(cartItems.length, (index)=>{"listing_id": cartItems[index].listingId, "quantity": cartItems[index].selectQuantity}),
                
                };
                if(voucherRes.data != null ){
                  data["voucher_code"] = voucherRes.data!.code;
                }
                ref.read(orderProvider.notifier).placeOrder(data, widget.count);
                
               
              },
            ),
          );
        },
      ),
      onButtonTap: () {
        
      },
      bottomButtonText: "place order",
      title: "Cart",
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(AppTheme.horizontalPadding),
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final product = cartList[index];
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.r,
                        vertical: 15.r,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Color.fromRGBO(243, 243, 243, 1),
                      ),
                      child: Row(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          DisplayNetworkImage(imageUrl: product.image, width: 57.r, height: 73.r ,),
                        
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
                                        style: context.textStyle.titleSmall!
                                            .copyWith(
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
                                        style: context.textStyle.displayMedium!
                                            .copyWith(
                                              color: AppColors.secondaryColor,
                                            ),
                                      ),
                                      TextSpan(
                                        text: "\$${product.price}",
                                        style: context.textStyle.displayMedium!
                                            .copyWith(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Color.fromRGBO(
                                                91,
                                                91,
                                                91,
                                                1,
                                              ),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                8.ph,
                                Text(
                                  Helper.getTypeTitle(product.type!) ==
                                          "Best By Products"
                                      ? "Best By: ${Helper.selectDateFormat(product.bestByDate)}"
                                      : product.description,
                                  style: context.textStyle.bodySmall!.copyWith(
                                    color: AppColors.primaryTextColor
                                        .withValues(alpha: 0.7),
                                  ),
                                ),

                                // 2.ph,
                              ],
                            ),
                          ),
                          Container(
                            // height: 30.h,
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
                                  child: SvgPicture.asset(
                                    product.quantity == 1
                                        ? Assets.deleteIcon
                                        : Assets.minusSquareIcon,
                                  ),
                                ),
                                Text(
                                  "${product.selectQuantity}",
                                  style: context.textStyle.displayMedium,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    addQuantity(product);
                                  },
                                  child: SvgPicture.asset(
                                    Assets.plusSquareIcon,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => 10.ph,
                  itemCount: cartList.length,
                ),
                10.ph,
                
                  Text(
                    "Promotional Products",
                    style: context.textStyle.headlineMedium,
                  ),
                  10.ph,
                  SizedBox(
          height: 125.h,
           child: Consumer(
              builder: (context, ref, child) {
                final promotionalState = ref.watch(
                  homeProvider.select(
                    (e) => (
                      e.getPromotionalProductsApiResponse,
                      e.promotionalProducts,
                    ),
                  ),
                );
                final promotionalProducts = promotionalState.$2 ?? [];
                return AsyncStateHandler(
                  status: promotionalState.$1.status,
                  dataList: promotionalProducts,
               
                  itemBuilder: (context, index) {
                    final product = promotionalProducts[index];
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.r,
                        vertical: 15.r,
                      ),
                      height: double.infinity,
                      width: context.screenwidth * 0.35,
                      decoration: AppTheme.productBoxDecoration,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            right: 0,
                            bottom: -13.r,
                            child: IconButton(
                              visualDensity: VisualDensity(horizontal: -4.0),
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                // TODO: Add to cart logic
                              },
                              icon: SvgPicture.asset(Assets.addCircleIcon),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 3,
                            children: [
                              DisplayNetworkImage(imageUrl: product.image, width: 49.r, height: 61.r ,),
                              5.ph,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title,
                                    style: context.textStyle.displaySmall,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    product.category?.title ?? "Category",
                                    style: context.textStyle.bodySmall,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "\$${(product.discountedPrice as num).toStringAsFixed(2)}",
                                      style: context.textStyle.titleSmall,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  onRetry: () => fetchProducts(), // TODO: Get storeId
                );
              },
            ),
         ),
        
        10.ph,
                

                Text(
                  "Order Summary",
                  style: context.textStyle.bodyMedium!.copyWith(
                    fontSize: 18.sp,
                  ),
                ),
                Divider(),
                OrderDetailTitleWidget(title: "Item Total", value: "\$$total"),
                if(voucherRes.status == Status.completed && voucherRes.data != null &&voucherRes.data!.discountValue != 0)...[
                10.ph,
                OrderDetailTitleWidget(title: "Voucher Discount", value: "\$${voucherRes.data!.discountValue}"),

                ],
                10.ph,
            

                OrderDetailTitleWidget(title: "Total", value: "\$$total"),
                
                // if()
                if(voucherRes.status != Status.completed)...[
                  10.ph,
                  GestureDetector(
                  onTap: () {
                    AppRouter.push(VoucherApplyView(totalAmount: total,));
                  },
                  child: Row(
                    spacing: 10,
                    children: [
                      SvgPicture.asset(Assets.voucherOutlineIcon),
                      Text(
                        "Apply Voucher",
                        style: context.textStyle.displayMedium,
                      ),
                    ],
                  ),
                ),
              
                ],
                ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.horizontalPadding,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total", style: context.textStyle.displayMedium),
                    Text(
                      "\$$total",
                      style: context.textStyle.displayMedium!.copyWith(
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "\$${cartList.fold(0.0, (sum, item) => sum + item.price! * item.selectQuantity).toStringAsFixed(2)}",
                      style: context.textStyle.displaySmall!.copyWith(
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
