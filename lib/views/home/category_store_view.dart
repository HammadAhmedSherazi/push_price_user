import '../../export_all.dart';

class CategoryStoreView extends ConsumerStatefulWidget {
  final String title;
  final int categoryId;
  const CategoryStoreView({super.key, required this.title, required this.categoryId});

  @override
  ConsumerState<CategoryStoreView> createState() => _CategoryStoreViewState();
}

class _CategoryStoreViewState extends ConsumerState<CategoryStoreView> {
  final ScrollController _scrollController = ScrollController();
  int skip = 0;
  final int limit = 10;
  String search = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeProvider.notifier).getCategoryStores(
        categoryId: widget.categoryId,
        limit: limit,
        skip: skip,

      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      final homeState = ref.read(homeProvider);
      if (homeState.getCategoryStoresApiResponse.status != Status.loadingMore) {
        skip += limit;
        ref.read(homeProvider.notifier).getCategoryStores(
          categoryId: widget.categoryId,
          limit: limit,
          skip: skip,

        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final homeState = ref.watch(homeProvider.select((e) => (e.getCategoryStoresApiResponse, e.categoryStores)));
        final stores = homeState.$2 ?? [];
        return CustomScreenTemplate(
          title: widget.title,
          child: AsyncStateHandler(
            status: homeState.$1.status,
            dataList: stores,
            customSuccessWidget: GridView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(AppTheme.horizontalPadding),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stores.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10.r,
                crossAxisSpacing: 10.r,
                childAspectRatio: 0.87,
              ),
              itemBuilder: (context, index) {
                final store = stores[index];
                return StoreCardWidget(data: store);
              },
            ),
            itemBuilder: null,
            onRetry: () {
              ref.read(homeProvider.notifier).getCategoryStores(
                categoryId: widget.categoryId,
                limit: limit,
                skip: 0,

              );
            },
          ),
        );
      },
    );
  }
}
