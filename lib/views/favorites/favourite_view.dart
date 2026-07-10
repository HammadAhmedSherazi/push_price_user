import 'dart:async';

import 'package:push_price_user/providers/favourite_provider/favourite_provider.dart';
import 'package:push_price_user/views/favorites/add_new_favourite_view.dart';

import '../../export_all.dart';
import '../../models/favourite_data_model.dart';
import '../../widget/overlapping_images_widget.dart';

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
  void showDeleteFavouriteItemDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: context.isTablet ? 48 : 24,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color(0xFFF2F7FA),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.dialogMaxWidth),
            child: SizedBox(
            width: context.isTablet ? context.dialogMaxWidth : double.infinity,
            child: Padding(
            padding: EdgeInsets.all(context.pageHorizontalPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(context.tr('delete'), style: context.textStyle.displayMedium!.copyWith(fontSize: 18.sp)),
                10.ph,
                Text(
                  context.tr('are_you_sure_you_want_to_delete'),
                  textAlign: TextAlign.center,
                  style: context.textStyle.bodyMedium!.copyWith(color: Colors.grey),
                ),
                30.ph,
                Row(
                  spacing: 20,
                  children: [
                    Expanded(
                      child: CustomOutlineButtonWidget(
                        title: context.tr("cancel"),
                        compact: true,
                        onPressed: () => AppRouter.back(),
                      ),
                    ),
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, child) {
                          final isLoad = ref.watch(favouriteProvider.select((e)=>e.deleteFavouriteApiResponse.status)) == Status.loading;
                          return CustomButtonWidget(
                            isLoad: isLoad,
                            color: Color.fromRGBO(174, 27, 13, 1),
                            title: context.tr("delete"),
                            compact: true,
                            onPressed: () {
                              ref.read(favouriteProvider.notifier).deleteFavourite(favouriteId: id);
                            },
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ),
          ),
        );
      },
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
        
        appBar: CustomAppBarWidget(
          height: context.tabAppBarWithSearchHeight,
          title: context.tr("my_favourite"),
          children: [
            CustomSearchBarWidget(
              hintText: context.tr('hinted_search_text'),
              onTapOutside: (x) {
                FocusScope.of(context).unfocus();
              },
              onChanged: (value) {
                if (_searchDebounce?.isActive ?? false) {
                  _searchDebounce!.cancel();
                }

                _searchDebounce = Timer(
                  const Duration(milliseconds: 500),
                  () {
                    if (value.length >= 3) {
                      fetchFavouriteProducts(search: value);
                    }
                  },
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final data = ref.watch(favouriteProvider.select(
                    (e) => (e.getFavouriteProductsApiResponse, e.favouriteProducts),
                  ));
                  final response = data.$1;
                  final list = data.$2 ?? [];
                  return AsyncStateHandler(
                    dataList: list,
                    status: response.status,
                    padding: EdgeInsets.symmetric(
                      horizontal: context.pageHorizontalPadding,
                      vertical: 10.ih,
                    ),
                    itemBuilder: (context, index) {
                      final favourite = list[index];
                      return FavouriteTitleWidget(
                        favourite: favourite,
                        onEditCall: () {
                          AppRouter.push(
                            AddNewFavouriteView(
                              isSignUp: false,
                              data: favourite,
                            ),
                          );
                        },
                        onDeleteCall: () {
                          showDeleteFavouriteItemDialog(
                            context,
                            favourite.favoriteId,
                          );
                        },
                      );
                    },
                    onRetry: () => fetchFavouriteProducts(),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.pageHorizontalPadding,
                12.ih,
                context.pageHorizontalPadding,
                context.bottomNavBottomPadding + 12.ih,
              ),
              child: CustomButtonWidget(
                title: context.tr("add_new_favorite"),
                onPressed: () {
                  AppRouter.push(SearchProductView());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavouriteTitleWidget extends StatelessWidget {
  final VoidCallback ? onEditCall;
  final VoidCallback ? onDeleteCall;
  const FavouriteTitleWidget({
    super.key,
    required this.favourite,
    this.onEditCall,
    this.onDeleteCall

  });

  final FavouriteModel favourite;

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
      // spacing: 10,
      children: [
        // Image.asset(Assets.groceryBag,width: 57.w, height: 70.h,),
        if(favourite.products.length > 1)...[
          OverlappingImages(images: favourite.products.map((p) => p.image).toList())
        ]
        else ...[
          DisplayNetworkImage(imageUrl: favourite.products.first.image,width: 57, height: 70,)
        ],
        20.pw,
        
        Expanded(
          child: Text(favourite.products.length > 1 ? favourite.products.map((p) => p.title).join(', ')  : favourite.products.first.title, style: context.textStyle.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis,),
        ),
        if(onEditCall == null)
        20.pw,
        if(onEditCall != null)
        IconButton(
          visualDensity: VisualDensity(
            horizontal: -4.0
          ),
          padding: EdgeInsets.zero,
          onPressed: onEditCall, icon: Icon(Icons.edit, color: AppColors.secondaryColor,)),
        if(onDeleteCall != null)
        IconButton(
          visualDensity: VisualDensity(
            horizontal: -4.0
          ),
          padding: EdgeInsets.zero,
          onPressed: onDeleteCall, icon: Icon(Icons.delete, color: Color.fromRGBO(174, 27, 13, 1),)),
        
    
    
      ],
    ),
                    );
  }
}
