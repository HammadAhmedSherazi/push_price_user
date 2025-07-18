import 'package:push_price_user/models/store_data_model.dart';
import 'package:push_price_user/utils/extension.dart';

import '../../export_all.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool travelMode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(context.screenheight * 0.21),
        child: Container(
          padding: EdgeInsets.only(
            top: 40.r,
            left: AppTheme.horizontalPadding,
            right: AppTheme.horizontalPadding,
            bottom: 20.r
          ),
          width: double.infinity, height: double.infinity,

          decoration: BoxDecoration(
            color: Color.fromRGBO(230, 243, 253, 0.5),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(35.r)
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: context.screenwidth * 0.25,
                    child: Row(

                      children: [
                        CircleAvatar(
                          backgroundColor: Color.fromRGBO(234, 241, 255, 0.6),
                          radius: 20.r,
                          child: SvgPicture.asset(Assets.menuNavIcon),
                        ),
                      ],
                    ),
                  ),
               
                  Text("Home",style: context.textStyle.displayMedium,),
                
                  SizedBox(
                    width: context.screenwidth * 0.25,
                    child: Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          backgroundColor: Color.fromRGBO(234, 241, 255, 0.6),
                          radius: 20.r,
                          child: SvgPicture.asset(Assets.notificationIcon),
                        ),
                        CircleAvatar(
                          backgroundColor: Color.fromRGBO(234, 241, 255, 0.6),
                          radius: 20.r,
                          child: SvgPicture.asset(Assets.addCartIcon),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              CustomSearchBarWidget(hintText: "hsdjhsj", suffixIcon: SvgPicture.asset(Assets.filterIcon),),
              Row(
                
                children: [
                  SvgPicture.asset(Assets.locationIcon),
                  10.pw,
                 
                  Expanded(
                    child: Column(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Home", style: context.textStyle.headlineMedium,),
                        Text("ABC, Street Lorem Ipsum", style: context.textStyle.titleSmall,),
                    
                      ],
                    ),
                  ),
                  
                  Text("Travel Mode",style: context.textStyle.displayMedium,),
                  10.pw,
                  Switch.adaptive(value: false, onChanged: (val){})
                ],
              )
            ],
          ),
          ),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppTheme.horizontalPadding),
        children: [
          SpecialOfferBannerSection(),
          10.ph,
          CategoriesSection(),
          10.ph,
          PopularStoresSection(),
          10.ph,
          NearbyStoresSection()
        ],
      ),
    );
  }
}

class PopularStoresSection extends StatelessWidget {
  const PopularStoresSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<StoreDataModel> stores = List.generate(10, (index)=> StoreDataModel(title: "Abc Store", address: "abc street", rating: 4.5, icon: Assets.store));
    return SizedBox(
      height: context.screenheight * 0.20,
      child: Column(
        spacing: 10,
        children: [
          Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
          Text("Popular Stores", style: context.textStyle.displayMedium,),
          TextButton(
            style: ButtonStyle(
              padding: WidgetStatePropertyAll(EdgeInsets.zero),
              visualDensity: VisualDensity(
                vertical: -4.0,
                horizontal: -4.0
              ),
            ),
            onPressed: (){}, child: Text("See All", style: context.textStyle.bodySmall!.copyWith(
            color: context.colors.primary,decoration: TextDecoration.underline
          ),))
          
      ],
    ),
    Expanded(
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final store = stores[index];
          return StoreCardWidget(data: store,);
        }, separatorBuilder: (context, index)=>10.pw, itemCount: stores.length))
           
        ],
      ),
    );
  }
}

class StoreCardWidget extends StatelessWidget {
  final StoreDataModel data;
  const StoreCardWidget({
    super.key,
    required this.data
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      // width: 94.w,
      padding: EdgeInsets.symmetric(
        horizontal: 20.r
      ),
      decoration: BoxDecoration(
        color: Color.fromRGBO(243, 243, 243, 1),
        borderRadius: BorderRadius.circular(10.r)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(data.icon, width: 50.r, height: 50.r,),
          Text(data.title , maxLines: 1, style: context.textStyle.bodySmall,),
          Text(data.address, style: context.textStyle.titleSmall,maxLines: 1,),
          Row(
            spacing: 4,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, color: Color.fromRGBO(255, 144, 28, 1),),
              Text(data.rating.toString())
            ],
          )
        ],
      ),
    );
  }
}

class NearbyStoresSection extends StatelessWidget {
  const NearbyStoresSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
     final List<StoreDataModel> stores = List.generate(10, (index)=> StoreDataModel(title: "Abc Store", address: "abc street", rating: 4.5, icon: Assets.store));
    return SizedBox(
      height: context.screenheight * 0.20,
      child: Column(
        spacing: 10,
        children: [
          Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
          Text("Nearby Stores", style: context.textStyle.displayMedium,),
          TextButton(
            style: ButtonStyle(
              padding: WidgetStatePropertyAll(EdgeInsets.zero),
              visualDensity: VisualDensity(
                vertical: -4.0,
                horizontal: -4.0
              ),
            ),
            onPressed: (){}, child: Text("See All", style: context.textStyle.bodySmall!.copyWith(
            color: context.colors.primary,decoration: TextDecoration.underline
          ),))
          
      ],
    ),
     Expanded(
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final store = stores[index];
          return StoreCardWidget(data: store,);
        }, separatorBuilder: (context, index)=>10.pw, itemCount: stores.length))
           
        ],
      ),
    );
  }
}


class CategoriesSection extends StatelessWidget {
  const CategoriesSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<CategoryDataModel> categories = [
      CategoryDataModel(title: "Fruits", icon: Assets.fruits),
      CategoryDataModel(title: "Vegtables", icon: Assets.vegetable),
      CategoryDataModel(title: "Meat", icon: Assets.meat),
      CategoryDataModel(title: "Sea Food", icon: Assets.seaFood),
      CategoryDataModel(title: "Groceries", icon: Assets.grocery),
    ];
    return SizedBox(
      height: context.screenheight * 0.17,
      child: Column(
        spacing: 10,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Text("Categories", style: context.textStyle.displayMedium,),
                TextButton(
                  style: ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.zero),
                    visualDensity: VisualDensity(
                      vertical: -4.0,
                      horizontal: -4.0
                    ),
                  ),
                  onPressed: (){}, child: Text("See All", style: context.textStyle.bodySmall!.copyWith(
                  color: context.colors.primary,decoration: TextDecoration.underline
                ),))
      
            ],
          ),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final category = categories[index];
                return SizedBox(
                width: context.screenwidth * 0.17,
                child: Column(
                  spacing: 10,
                  children: [
                    CircleAvatar(
                      radius: 25.r,
                      backgroundColor: Color.fromRGBO(238, 247, 254, 1),
                      child: Padding(
                        padding:  EdgeInsets.all(5.r),
                        child: Image.asset(category.icon, ),
                      ),
                
                    ),
                    Text(category.title , style: context.textStyle.bodyMedium,maxLines: 2, textAlign: TextAlign.center,)
                  ],
                ),
              );
              }, separatorBuilder: (context, index)=>5.pw, itemCount: categories.length))
        ],
      ),
    );
  }
}

class SpecialOfferBannerSection extends StatelessWidget {
  const SpecialOfferBannerSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenheight * 0.20,
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Special Offers", style: context.textStyle.displayMedium,),
          Expanded(
            child: ClipRRect(
              child: Image.asset(Assets.specialDiscountBanner, fit: BoxFit.contain,),
            )
          )
        ],
      ),
    );
  }
}
