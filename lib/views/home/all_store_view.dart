import '../../export_all.dart';

class AllStoreView extends StatelessWidget {
  final String title;
  const AllStoreView({super.key, required this.title});

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

    return CustomScreenTemplate(title: title, child:GridView.builder(
          // padding: const EdgeInsets.all(12),
          shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(AppTheme.horizontalPadding),
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
        ) );
  }
}