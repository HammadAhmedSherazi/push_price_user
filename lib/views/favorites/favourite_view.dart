import 'package:push_price_user/utils/extension.dart';
import '../../export_all.dart';

class FavouriteView extends StatefulWidget {
  final ScrollController scrollController;
  const FavouriteView({super.key, required this.scrollController});

  @override
  State<FavouriteView> createState() => _FavouriteViewState();
}

class _FavouriteViewState extends State<FavouriteView> {
  final List<ProductDataModel> products = [
    ProductDataModel(title: "ABC Product", description: "ABC Category", image: Assets.groceryBag)
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom:true,
      top: false,
      child: Scaffold(
        
        appBar: CustomAppBarWidget(height: context.screenheight * 0.15, title: "My Favorites", children: [
          CustomSearchBarWidget(hintText: "Hinted search text", onTapOutside: (x){
             FocusScope.of(context).unfocus();
          },)
        ]),
        body: Column(
          children: [
            Expanded(
              child: ListView.separated(
                controller: widget.scrollController,
                padding: EdgeInsets.all(AppTheme.horizontalPadding),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductTitleWidget(product: product);
                }, separatorBuilder: (context, index)=> 10.ph, itemCount: products.length),
            ),
            Padding(padding: EdgeInsets.all(AppTheme.horizontalPadding), child: CustomButtonWidget(title: "add new favorite", onPressed: (){
              AppRouter.push(SearchProductView());
            }),),
           ],
        ),
      ),
    );
  }
}

class ProductTitleWidget extends StatelessWidget {
  const ProductTitleWidget({
    super.key,
    required this.product,
  });

  final ProductDataModel product;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        Image.asset(product.image, width: 57.w, height: 70.h,),
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
        20.pw
       
      ],
    ),
                    );
  }
}