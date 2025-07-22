import 'package:push_price_user/utils/extension.dart';
import '../../export_all.dart';


class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: CustomAppBarWidget(height: context.screenheight * 0.15, title: "Explore", children: [
        CustomSearchBarWidget(hintText: "Hinted search text")
      ]),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.horizontalPadding,
          vertical: AppTheme.horizontalPadding,
        ),
        children: [
          PopularStoresSection(),
          10.ph,
          NearbyStoreGirdViewSection()
        ],
      ),
     
    );
  }
}

class NearbyStoreGirdViewSection extends StatelessWidget {
  const NearbyStoreGirdViewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<StoreDataModel> stores = List.generate(
      16, // 4 items x 4 rows = 16
      (index) => StoreDataModel(
        title: "Abc Store",
        address: "abc street",
        rating: 4.5,
        icon: Assets.store,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Nearby Stores", style: context.textStyle.displayMedium),
            // TextButton(
            //   style: ButtonStyle(
            //     padding: WidgetStatePropertyAll(EdgeInsets.zero),
            //     visualDensity: VisualDensity(horizontal: -4, vertical: -4),
            //   ),
            //   onPressed: () {},
            //   child: Text(
            //     "See All",
            //     style: context.textStyle.bodySmall!.copyWith(
            //       color: context.colors.primary,
            //       decoration: TextDecoration.underline,
            //     ),
            //   ),
            // ),
          ],
        ),
        GridView.builder(
          // padding: const EdgeInsets.all(12),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stores.length,
          gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 4 items per row
            mainAxisSpacing: 10.r,
            crossAxisSpacing: 10.r,

            childAspectRatio: 0.87, // Adjust as per your card design
          ),
          itemBuilder: (context, index) {
            final store = stores[index];
            return StoreCardWidget(data: store);
          },
        ),
      ],
    );
  }
}