import 'dart:async';

import 'package:push_price_user/providers/favourite_provider/favourite_provider.dart';
import 'package:push_price_user/views/favorites/add_new_favourite_view.dart';

import '../../utils/extension.dart';
import '../../export_all.dart';

class FavouriteView extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  const FavouriteView({super.key, required this.scrollController});

  @override
  ConsumerState<FavouriteView> createState() => _FavouriteViewState();
}

class _FavouriteViewState extends ConsumerState<FavouriteView> {
  Timer? _searchDebounce;
  @override
  void initState() {
    super.initState();
    Future.microtask((){
      fetchFavouriteProducts();
    });
    
  }
  void fetchFavouriteProducts({String? search}){
    ref.read(favouriteProvider.notifier).getFavouriteProducts(
      search: search
    );
  }
  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom:true,
      top: false,
      child: Scaffold(
        
        appBar: CustomAppBarWidget(height: context.screenheight * 0.15, title: "My Favorites", children: [
          CustomSearchBarWidget(
            hintText: "Hinted search text",
             onTapOutside: (x){
             FocusScope.of(context).unfocus();
          }, onChanged:(value){
             if (_searchDebounce?.isActive ?? false) {
                        _searchDebounce!.cancel();
                      }
          
                      _searchDebounce = Timer(
                        const Duration(milliseconds: 500),
                        () {
                          if (value.length >= 3) {
                            fetchFavouriteProducts(search: value);
                            
                          }
                          // else{
                          //   fetchProduct(skip: 0);
                          // }
                        },
                      );
          },)
        ]),
        body: Column(
          children: [
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final data = ref.watch(favouriteProvider.select((e)=>(e.getFavouriteProductsApiResponse, e.favouriteProducts)));
                  final response = data.$1;
                  final list = data.$2 ?? [];
                  return AsyncStateHandler(
                   dataList: list,
                   status: response.status,
                    itemBuilder: (context, index) {
                      final product = list[index];
                      return ProductTitleWidget(product: product, onEditCall: (){
                        // AppRouter.push()
                        AppRouter.push(AddNewFavouriteView(isSignUp: false, isEdit: true,));
                      },);
                    }, onRetry: ()=>fetchFavouriteProducts(), );
                }
              ),
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
  final VoidCallback ? onEditCall;
  const ProductTitleWidget({
    super.key,
    required this.product,
    this.onEditCall
  });

  final ProductDataModel product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        AppRouter.push(ProductDetailView(quatity: 0, product: product, discount: 0, storeId: 1,));
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