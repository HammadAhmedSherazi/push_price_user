import '../../export_all.dart';
import '../../utils/extension.dart';

class ExploreView extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  const ExploreView({super.key, required this.scrollController});

  @override
  ConsumerState<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  @override
  void initState() {
    super.initState();
    Future.microtask((){
      ref.read(homeProvider.notifier).getStores(limit: 10, skip: 0);
      ref.read(homeProvider.notifier).getNearbyStores(limit: 10, skip: 0);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarWidget(
        height: context.screenheight * 0.15,
        title: "Explore",
        children: [
          CustomSearchBarWidget(
            hintText: "Hinted search text",
            onTapOutside: (v) {
              FocusScope.of(context).unfocus();
            },
          ),
        ],
      ),
      body: ListView(
        controller: widget.scrollController,
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.horizontalPadding,
          vertical: AppTheme.horizontalPadding,
        ),
        children: [PopularStoresSection(), 10.ph, NearbyStoreGirdViewSection()],
      ),
    );
  }
}

class NearbyStoreGirdViewSection extends StatelessWidget {
  const NearbyStoreGirdViewSection({super.key});

  @override
  Widget build(BuildContext context) {
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
        Consumer(
          builder: (context, ref, child) {
            final data = ref.watch(homeProvider.select((e)=>(e.getNearbyStoresApiResponse, e.nearbyStores)));
            final response = data.$1;
            final list = data.$2 ?? [];
            return AsyncStateHandler(
              status: response.status,
              dataList: list,
              customSuccessWidget: GridView.builder(
          // padding: const EdgeInsets.all(12),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount:list.length,
          gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 4 items per row
            mainAxisSpacing: 10.r,
            crossAxisSpacing: 10.r,

            childAspectRatio: 0.87, // Adjust as per your card design
          ),
          itemBuilder: (context, index) {
            final store = list[index];
            return StoreCardWidget(data: store);
          },
        ),
              itemBuilder: null,
              onRetry: (){
                ref.read(homeProvider.notifier).getNearbyStores(limit: 10, skip: 0);
              },
            );
          },
        ),
      ],
    );
  }
}
