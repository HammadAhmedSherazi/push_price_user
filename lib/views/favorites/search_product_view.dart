import 'dart:async';

import 'package:push_price_user/providers/favourite_provider/favourite_provider.dart';
import 'package:push_price_user/views/favorites/add_new_favourite_view.dart';

import '../../export_all.dart';
import '../../utils/extension.dart';

class SearchProductView extends ConsumerStatefulWidget {
  final bool? isSignUp;
  const SearchProductView({super.key, this.isSignUp = false});

  @override
  ConsumerState<SearchProductView> createState() => _SearchProductViewState();
}

class ProductTitleWidget extends StatelessWidget {
  final VoidCallback ? onEditCall;
  const ProductTitleWidget({
    super.key,
    required this.product,
    this.onEditCall
  });

  final ProductSelectionDataModel product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        // AppRouter.push(ProductDetailView(quatity: 0, product: product, discount: 0, storeId: 1,));
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10.r,
          vertical: 3.r
        ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: Color.fromRGBO(243, 243, 243, 1)
      ),
      child: Row(
        spacing: 10,
        children: [
          DisplayNetworkImage(imageUrl:  product.image, width: 57.w, height: 70.h,),
          Expanded(
            child: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title, style: context.textStyle.bodyMedium),
                Text(product.description, style: context.textStyle.bodySmall!.copyWith(
                  color: AppColors.primaryTextColor.withValues(alpha: 0.7),

                )),

              ],
            ),
          ),
          if(onEditCall == null)
          20.pw,
          if(onEditCall != null)
          IconButton(onPressed: onEditCall, icon: Icon(Icons.edit, color: AppColors.secondaryColor,))


        ],
      ),
                      ),
    );
  }
}

class _SearchProductViewState extends ConsumerState<SearchProductView> {
  Timer? _searchDebounce;
  //  void addFavoriteProduct(int index){
  //   final product = products[index];
  //   products[index] = product.copyWith(isSelect: !product.isSelect);
  //   setState(() {

  //   });
  //  }
  //  List<ProductSelectionDataModel> products = List.generate(5, (index)=> ProductSelectionDataModel(title: "ABC Product", description: "ABC Category", image: Assets.groceryBag, isSelect: false, discountedPrice: 0.0));
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      fetchProducts(skip: 0, limit: 10);
    });
  }

  void fetchProducts({
    required int skip,
    required int limit,
    int? categoryId,
    String? search,
    int? storeId,
  }) {
    ref
        .read(favouriteProvider.notifier)
        .getProducts(
          skip: skip,
          limit: limit,
          search: search,
          categoryId: categoryId,
          storeId: storeId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(
      showBottomButton:
          ref
              .watch(favouriteProvider.select((e) => e.products ?? []))
              .indexWhere((item) => item.isSelect) !=
          -1,
      bottomButtonText: "next",
      onButtonTap: () {
         AppRouter.push(AddNewFavouriteView(isSignUp: widget.isSignUp!));
      },
      title: "Search",
      actionWidget: Row(
        children: [
          GestureDetector(
            onTap: () {
              AppRouter.push(ScanView(isSignUp: widget.isSignUp!));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 10.r),
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Row(
                spacing: 5,
                children: [
                  SvgPicture.asset(Assets.menuScanBarIcon),
                  Text(
                    "Scan",
                    style: context.textStyle.displayMedium!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          15.pw,
        ],
      ),
      child: SizedBox(
        height: double.infinity,
        child: Column(
          children: [
            20.ph,
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppTheme.horizontalPadding,
              ),
              child: CustomSearchBarWidget(
                hintText: "Hinted search text",
                onChanged:(value){
                  if (_searchDebounce?.isActive ?? false) {
                        _searchDebounce!.cancel();
                      }
          
                      _searchDebounce = Timer(
                        const Duration(milliseconds: 500),
                        () {
                          if (value.length >= 3) {
                            fetchProducts(search: value, skip: 0, limit: 10, );
                            
                          }
                          // else{
                          //   fetchProduct(skip: 0);
                          // }
                        },
                      );
                },
                suffixIcon: SvgPicture.asset(Assets.filterIcon),
                onTapOutside: (v) {
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final data = ref.watch(
                    favouriteProvider.select(
                      (e) => ( e.products, e.getProductsApiResponse),
                    ),
                  );
                  final response = data.$2;
                  final list= data.$1 ?? [];
                  return AsyncStateHandler(
                    dataList: list,
                    itemBuilder: (context, index) {
                      final product = list[index];
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          ProductTitleWidget(product: product),
                          Positioned(
                            right: 15.r,
                            child: IconButton(
                              onPressed: () {
                                ref
                                    .read(favouriteProvider.notifier)
                                    .selectProduct(index);
                              },
                              icon: Icon(
                                !product.isSelect
                                    ? Icons.check_box_outline_blank
                                    : Icons.check_box,
                                color: AppColors.secondaryColor,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    status: response.status,
                    onRetry: () => fetchProducts(skip: 0, limit: 10),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
