import '../../export_all.dart';

class AllStoreView extends ConsumerStatefulWidget {
  final String title;
  const AllStoreView({super.key, required this.title});

  @override
  ConsumerState<AllStoreView> createState() => _AllStoreViewState();
}

class _AllStoreViewState extends ConsumerState<AllStoreView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(homeProvider.notifier).getStores(limit: 20, skip: 0);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        final homeState = ref.read(homeProvider);
        if (homeState.getStoresApiResponse.status != Status.loadingMore) {
          ref.read(homeProvider.notifier).getStores(
            limit: 20,
            skip: homeState.storesSkip,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final stores = homeState.stores ?? [];

    return CustomScreenTemplate(
      title: widget.title,
      child: AsyncStateHandler(
        status: homeState.getStoresApiResponse.status,
        dataList: stores,
        itemBuilder: null,
        scrollController: _scrollController,
        padding: EdgeInsets.all(AppTheme.horizontalPadding),
        customSuccessWidget: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(AppTheme.horizontalPadding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10.r,
            crossAxisSpacing: 10.r,
            childAspectRatio: 0.87,
          ),
          itemCount: stores.length,
          itemBuilder: (context, index) {
            final store = stores[index];
            return StoreCardWidget(data: store);
          },
        ),
        onRetry: () {
          ref.read(homeProvider.notifier).getStores(limit: 20, skip: 0);
        },
      ),
    );
  }
}
