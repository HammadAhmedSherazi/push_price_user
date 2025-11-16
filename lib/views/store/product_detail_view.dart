import '../../export_all.dart';
import '../../utils/extension.dart';

class ProductDetailView extends ConsumerStatefulWidget {
  final int quatity;
  final ProductDataModel product;
  final int storeId;
  final num discount;
  final bool? isFavourite;
  const ProductDetailView({
    super.key,
    required this.quatity,
    required this.product,
    required this.discount,
    required this.storeId,
    this.isFavourite = false

  });

  @override
  ConsumerState<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends ConsumerState<ProductDetailView> {
  int quantity = 0;
  int count = 0;
  void addQuantity() {
    setState(() {
      quantity++;
      count++;
    });
  }

  void removeQuantity() {
    if (quantity > 0) {
      setState(() {
        quantity--;
        count--;
      });
    }
  }

  @override
  void initState() {
    quantity = widget.quatity;
    count = widget.quatity;
    super.initState();
    // Fetch promotional products
    Future.microtask(() {
      fetchProducts();
    });
  }

  void fetchProducts() {
    ref
        .read(homeProvider.notifier)
        .getPromotionalProducts(
          storeId: widget.storeId,
          skip: 0,
          limit: 10,
        ); // TODO: Get storeId from context or props
  }

  int listCount = 5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomSheet: count > 0 && !widget.isFavourite!
          ? Padding(
              padding: EdgeInsets.all(AppTheme.horizontalPadding),
              child: CustomButtonWidget(
                title: "",
                onPressed: () {
                  AppRouter.push(CartView(count: 5,storeId: widget.storeId,));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 20.r,
                        height: 20.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 0.8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "$count",
                          style: context.textStyle.titleSmall!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        "View Your Cart",
                        style: context.textStyle.bodyMedium!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "\$${count * 80}",
                        style: context.textStyle.bodySmall!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(context.screenheight * 0.16),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.primaryAppBarColor,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r)),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              DisplayNetworkImage(imageUrl: widget.product.image , width: 80.r, height: 80.r),
              Positioned(
                left: 20.r,
                top: 50.r,
                child: GestureDetector(
                  onTap: () {
                    AppRouter.back();
                  },
                  child: Container(
                    width: 25.r,
                    height: 25.r,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 18.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppTheme.horizontalPadding),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: widget.product.title,
                  style: context.textStyle.displayMedium!.copyWith(
                    fontSize: 16.sp,
                  ),
                ),

                TextSpan(
                  text: "  ${widget.discount}% Off",
                  style: context.textStyle.bodyMedium!.copyWith(
                    color: AppColors.secondaryColor,
                  ),
                ),
              ],
            ),
          ),
          10.ph,
          Text(
            widget.product.description,
            style: context.textStyle.titleSmall,
            maxLines: 4,
          ),
          5.ph,
          Text.rich(
            textAlign: TextAlign.start,
            TextSpan(
              children: [
                TextSpan(
                  text: "\$${widget.product.discountedPrice} ",
                  style: context.textStyle.displayMedium!.copyWith(
                    color: AppColors.secondaryColor,
                  ),
                ),
                TextSpan(
                  text: "\$${widget.product.price}",
                  style: context.textStyle.displayMedium!.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: Color.fromRGBO(91, 91, 91, 1),
                  ),
                ),
              ],
            ),
          ),
          if(!widget.isFavourite!)...[
             10.ph,
          Row(
            children: quantity > 0
                ? [
                    Container(
                      // height: 30.h,
                      padding: EdgeInsets.all(8.r),
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
                              removeQuantity();
                            },
                            child: quantity == 1
                                ? SvgPicture.asset(Assets.deleteIcon)
                                : SvgPicture.asset(Assets.minusSquareIcon),
                          ),
                          Text(
                            "$quantity",
                            style: context.textStyle.displayMedium,
                          ),

                          GestureDetector(
                            onTap: () {
                              addQuantity();
                            },
                            child: SvgPicture.asset(Assets.plusSquareIcon),
                          ),
                        ],
                      ),
                    ),
                  ]
                : [
                    GestureDetector(
                      onTap: () {
                        addQuantity();
                      },
                      child: SvgPicture.asset(Assets.addCircleIcon),
                    ),
                  ],
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
                                    product.title ,
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
        
        
          ],
         ],
      ),
    );
  }
}
