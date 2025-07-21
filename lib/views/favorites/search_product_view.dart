import 'package:push_price_user/utils/extension.dart';

import '../../export_all.dart';

class SearchProductView extends StatefulWidget {
  const SearchProductView({super.key});

  @override
  State<SearchProductView> createState() => _SearchProductViewState();
}

class _SearchProductViewState extends State<SearchProductView> {
   addFavoriteProduct(int index){
    final product = products[index];
    products[index] = product.copyWith(isSelect: !product.isSelect);
    setState(() {
      
    });
   }
   List<ProductSelectionDataModel> products = List.generate(5, (index)=> ProductSelectionDataModel(title: "ABC Product", description: "ABC Category", image: Assets.groceryBag, isSelect: false)); 
  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(
      showBottomButton: true,
      bottomButtonText: "next",
      onButtonTap: (){
        AppRouter.back();
      },
      title: "Search", actionWidget: Row(
      children: [
        GestureDetector(
          onTap: (){
            AppRouter.push(ScanView());
          },
          child: Container(
            
            padding: EdgeInsets.symmetric(
              horizontal: 15.r,
              vertical: 10.r
            ),
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(15.r)
          
            ),
            child: Row(
              spacing: 5,
              children: [
                SvgPicture.asset(Assets.menuScanBarIcon),
                Text("Scan", style: context.textStyle.displayMedium!.copyWith(
                  color: Colors.white
                ),)]
            ),
          ),
        ),
        15.pw
      ],
    ),child: SizedBox(
      height: double.infinity,
      child: Column(
        children: [
          20.ph,
          Padding(
            padding:  EdgeInsets.symmetric(
              horizontal: AppTheme.horizontalPadding
            ),
            child: CustomSearchBarWidget(hintText: "Hinted search text",  suffixIcon: SvgPicture.asset(Assets.filterIcon),),
          ),
          Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(AppTheme.horizontalPadding),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      ProductTitleWidget(product: product),
                      Positioned(
                        right: 15.r,
                        child: IconButton(onPressed: (){
                          addFavoriteProduct(index);
                        }, icon: Icon(!product.isSelect? Icons.check_box_outline_blank : Icons.check_box, color: AppColors.secondaryColor,)))
                    ],
                  );
                }, separatorBuilder: (context, index)=> 10.ph, itemCount: products.length),
            ),
        ],
      ),
    ));
  }
}