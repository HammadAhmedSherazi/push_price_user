import '../../utils/extension.dart';

import '../../export_all.dart';

class CartView extends StatefulWidget {
  final int? count;
  const CartView({super.key, this.count});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  void addQuantity(int index) {
    setState(() {
      myCartItem[index].quantity = myCartItem[index].quantity + 1;
    });
  }

  void removeQuantity(int index) {
    if (myCartItem[index].quantity > 1) {
      setState(() {
        myCartItem[index].quantity = myCartItem[index].quantity - 1;
      });
    }
    if(myCartItem[index].quantity == 1){
      setState(() {
        myCartItem.removeAt(index);
      });
    }
  }

  // ProductPurchasingDataModel product = ProductPurchasingDataModel(
  //   title: "ABC Product",
  //   description: "ABC Category",
  //   image: Assets.groceryBag,
  //   quantity: 1,
  //   discountAmount: 80.00,
  //   price: 99.99,
  // );

  List<ProductPurchasingDataModel> myCartItem = [
    ProductPurchasingDataModel(
      title: "ABC Product",
      description: "ABC Category",
      image: Assets.groceryBag,
      quantity: 1,
      discountAmount: 80.00,
      price: 99.99,
    ),
  ];
  List<ProductPurchasingDataModel> promotionalProducts = List.generate(
    5,
    (index) => ProductPurchasingDataModel(
      title: "ABC Product",
      description: "ABC Category",
      image: Assets.groceryBag,
      quantity: 1,
      discountAmount: 80.00,
      price: 99.99,
    ),
  );
  @override
  Widget build(BuildContext context) {
    final total = myCartItem.fold(0.0, (sum, item) => sum + item.discountAmount * item.quantity);
    return CustomScreenTemplate(
      showBottomButton: total > 0.0,
      onButtonTap: () {
        AppRouter.pushReplacement(
          OrderSuccessModifiedView(
            count:widget.count,
            message: "Your Order Has Been Placed Successfully!",
          ),
        );
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
                    final product = myCartItem[index];
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
                                        text: " 20% Off",
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
                                        text: "\$${product.discountAmount} ",
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
                                  "Best By: April 25, 2025",
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
                                    removeQuantity(index);
                                  },
                                  child: SvgPicture.asset(
                                 product.quantity == 1 ? Assets.deleteIcon :   Assets.minusSquareIcon,
                                  ),
                                ),
                                Text(
                                  "${product.quantity}",
                                  style: context.textStyle.displayMedium,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    addQuantity(index);
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
                  itemCount: myCartItem.length,
                ),
                10.ph,
                if (promotionalProducts.isNotEmpty) ...[
                  Text(
                    "Promotional Products",
                    style: context.textStyle.headlineMedium,
                  ),
                  10.ph,
                  SizedBox(
                    height: 125.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final ProductPurchasingDataModel product =
                            promotionalProducts[index];
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
                                  visualDensity: VisualDensity(
                                    horizontal: -4.0,
                                  ),
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    setState(() {
                                      myCartItem.add(product);
                                      promotionalProducts.removeAt(index);
                                    });
                                  },
                                  icon: SvgPicture.asset(Assets.addCircleIcon),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 3,
                                children: [
                                  Image.asset(Assets.groceryBag, width: 40.r),
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
                                        product.description,
                                        style: context.textStyle.bodySmall,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "\$ ${product.price}",
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
                      separatorBuilder: (context, index) => 10.pw,
                      itemCount: promotionalProducts.length,
                    ),
                  ),
                  10.ph,
                ],

                Text(
                  "Order Summary",
                  style: context.textStyle.bodyMedium!.copyWith(
                    fontSize: 18.sp,
                  ),
                ),
                Divider(),
                OrderDetailTitleWidget(
                  title: "Item Total",
                  value:
                      "\$$total",
                ),
                10.ph,
                OrderDetailTitleWidget(
                  title: "Total",
                  value:
                      "\$$total",
                ),
                10.ph,
                GestureDetector(
                  onTap: () {
                    AppRouter.push(VoucherApplyView());
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
                      "\$${myCartItem.fold(
  0.0,
  (sum, item) => sum + item.price! * item.quantity,
).toStringAsFixed(2)}",
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
