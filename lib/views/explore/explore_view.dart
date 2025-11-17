import 'dart:async';

import '../../export_all.dart';
import '../../utils/extension.dart';

class ExploreView extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  const ExploreView({super.key, required this.scrollController});

  @override
  ConsumerState<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  late TextEditingController _searchTextEditController;
  late ScrollController _scrollController;
  Timer? _searchDebounce;
  @override
  void initState() {
    super.initState();
    _searchTextEditController = TextEditingController();
    _scrollController = ScrollController();
    Future.microtask((){
      fetchStore();
      ref.read(homeProvider.notifier).getNearbyStores(limit: 10, skip: 0);
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        final homeState = ref.read(homeProvider);
        if (homeState.getStoresApiResponse.status != Status.loadingMore) {
          fetchStore(skip: homeState.storesSkip);
        }
      }
    });
  }
  void fetchStore({int? skip}){
    String? searchText = _searchTextEditController.text.length > 3?_searchTextEditController.text : null;
    ref.read(homeProvider.notifier).getStores(limit: 10, skip: skip?? 0, search: searchText);
  }
  bool searchFlag = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarWidget(
        height: context.screenheight * 0.15,
        title: "Explore",
        children: [
          CustomSearchBarWidget(
            controller: _searchTextEditController,
            hintText: "Hinted search text",
            onTapOutside: (v) {
              FocusScope.of(context).unfocus();
            },
            onChanged: (value){
              if (value.isNotEmpty) {
                      if (_searchDebounce?.isActive ?? false) {
                        _searchDebounce!.cancel();
                      }

                      _searchDebounce = Timer(
                        const Duration(milliseconds: 500),
                        () {
                          if (value.length >= 3) {
                            fetchStore();
                            if(!searchFlag){
                              setState(() {
                                searchFlag = true;
                              });
                            }
                            
                         
                          }
                          else{
                            if(searchFlag){
                              fetchStore();
                              setState(() {
                                searchFlag = false;
                              });
                            }
                          }
                        },
                      );
                    }
            },
          ),
        ],
      ),
      body: searchFlag ? Container(
        height: context.screenheight,
        width: context.screenwidth,
        padding:  EdgeInsets.all(AppTheme.horizontalPadding),
        child: DisplaySearchStore(
          scrollController: _scrollController,
        ),
      ) :ListView(
        controller: widget.scrollController,
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.horizontalPadding,
          vertical: AppTheme.horizontalPadding,
        ),
        children: [PopularStoresSection(), 10.ph, NearbyStoreGirdViewSection(
          scrollController: _scrollController,
        )],
      ),
    );
  }
}

class NearbyStoreGirdViewSection extends StatelessWidget {
  final ScrollController scrollController;
  const NearbyStoreGirdViewSection({super.key, required this.scrollController});

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
              boxHeight: context.screenheight * 0.35,
              customSuccessWidget: GridView.builder(
          // padding: const EdgeInsets.all(12),
          controller: scrollController,
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


class DisplaySearchStore extends StatelessWidget {
  final ScrollController scrollController;
  const DisplaySearchStore({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final homeState = ref.watch(homeProvider.select((e) => (e.getStoresApiResponse, e.stores)));
        final stores = homeState.$2 ?? [];
        return Column(
            spacing: 10,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Search Result", style: context.textStyle.displayMedium),
                ],
              ),
              Expanded(
                child: AsyncStateHandler(
              status: homeState.$1.status,
              dataList: stores,
              
              customSuccessWidget: GridView.builder(
          // padding: const EdgeInsets.all(12),
          controller: scrollController,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount:stores.length,
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
              itemBuilder: null,
              onRetry: (){
                ref.read(homeProvider.notifier).getNearbyStores(limit: 10, skip: 0);
              },
            )
        ,
              ),
            ],
          )
        ;
      },
    );
  
     
  }
}