import '../../utils/extension.dart';

import '../../export_all.dart';

class CategoryProductView extends StatefulWidget {
  final String title;
  const CategoryProductView({super.key, required this.title});

  @override
  State<CategoryProductView> createState() => _CategoryProductViewState();
}

class _CategoryProductViewState extends State<CategoryProductView> {
   int count = 0;
  num price = 0;
  final List<ProductPurchasingDataModel> products = [
    ProductPurchasingDataModel(
      title: "ABC Product",
      description: "ABC Category",
      image: Assets.groceryBag,
      quantity: 0,
      discount: 80.00,
      price: 99.99,
      
    ),
    ProductPurchasingDataModel(
      title: "ABC Product",
      description: "ABC Category",
      image: Assets.groceryBag,
      quantity: 0,
      discount: 80.00,
      price: 99.99,
    ),
  ];
  List<ProductPurchasingDataModel> cartList = [];

  void addQuantity(int index) {
    final product = products[index];
    setState(() {
      
      products[index] = product.copyWith(quantity: product.selectQuantity + 1);
      // cartList[index] = products[index];
      price += product.discountedPrice!;
      count++;

    });
  }
  void removeQuantity(int index){
    final product = products[index];
    if(product.selectQuantity >0){
       setState(() {
      
      products[index] = product.copyWith(quantity: product.selectQuantity - 1);
      // cartList[index] = products[index];
      price -= product.discountedPrice!;
      count--;
    });
    }
    else{
      setState(() {
        cartList.removeAt(index);
        if(count >0){
          count--;
          price -= product.discountedPrice!;
        }        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(
      showBottomButton: count >0,
      customBottomWidget: count >0? Padding(padding: EdgeInsets.all(AppTheme.horizontalPadding), child: CustomButtonWidget(title: "", onPressed: (){
        AppRouter.push(CartView(
          count: 3,
        ));
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
      title: widget.title, child: ListView.separated(
              padding: EdgeInsets.all(AppTheme.horizontalPadding),
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: (){
                    AppRouter.push(ProductDetailView(
                      quatity: product.selectQuantity,
                    ));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.r,
                      horizontal: 20.r,
                    ),
                    decoration: AppTheme.productBoxDecoration,
                    child: Stack(
                      children: [
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: product.selectQuantity > 0? Container(
                        // height: 30.h,
                        padding: EdgeInsets.all(5.r),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(30.r),
                            right: Radius.circular(30.r)
                          ),
                          border: Border.all(
                            width: 1,
                            color: AppColors.borderColor
                          )
                        ),
                        child: Row(
                          spacing: 10,
                          children: [
                            GestureDetector(
                              onTap: () {
                                removeQuantity(index);
                              },
                              child: product.quantity == 1? SvgPicture.asset(Assets.deleteIcon) : Container(
                                width: 17.r,
                                height: 17.r,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: AppColors.secondaryColor
                                  )

                                ),
                                child: Text("-", style: TextStyle(
                                  color: AppColors.secondaryColor,
                                  fontSize: 12.sp,
                                  height: 1.0
                                ),),
                              )),
                            Text("${product.quantity}", style: context.textStyle.displayMedium,),
                            GestureDetector(
                              onTap: (){
                                addQuantity(index);
                              },
                              child: SvgPicture.asset(Assets.addCircleIcon,)),
                          ],
                        ),
                      ): IconButton(
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity(
                              horizontal: -4.0,
                              vertical: -4.0,
                            ),
                            onPressed: () {
                              addQuantity(index);
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
                                     product.description,
                                    style: context.textStyle.bodySmall!.copyWith(
                                      color: AppColors.primaryTextColor
                                          .withValues(alpha: 0.7),
                                    ),
                                  ),
                  
                                  // 2.ph,
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
              separatorBuilder: (context, index) => 10.ph,
              itemCount: products.length,
            ),
         );
  }
}