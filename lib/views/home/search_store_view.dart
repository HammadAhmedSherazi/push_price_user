import 'dart:async';

import 'package:push_price_user/utils/extension.dart';

import '../../export_all.dart';

class SearchStoreView extends ConsumerStatefulWidget {
  const SearchStoreView({super.key});

  @override
  ConsumerState<SearchStoreView> createState() => _SearchStoreViewState();
}

class _SearchStoreViewState extends ConsumerState<SearchStoreView> {
  late final ScrollController _scrollController;
  late final TextEditingController _searchTextController;
  Timer? _searchDebounce;

  @override
  void initState() {
    _scrollController = ScrollController();
    _searchTextController = TextEditingController();
    Future.microtask(() {
      ref.read(homeProvider.notifier).getStores(limit: 20, skip: 0, search: "...");
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
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(title: context.tr('store'), child: Container(
      padding: EdgeInsets.all(AppTheme.horizontalPadding),
        height: double.infinity,
        child: Column(
          spacing: 20,
          children: [

            CustomSearchBarWidget(
              hintText: context.tr('hinted_search_text'),
              autoFocus: true,
              controller: _searchTextController,
              onChanged:(value){
                if (_searchDebounce?.isActive ?? false) {
                      _searchDebounce!.cancel();
                    }
                      
                    _searchDebounce = Timer(
                      const Duration(milliseconds: 500),
                      () {
                        if (value.length >= 3) {
                          ref.read(homeProvider.notifier).getStores(limit: 20, skip: 0, search: value);
                          
                        }
                        else{
                          ref.read(homeProvider.notifier).getStores(limit: 20, skip: 0, search: null);
                        }
                      },
                    );
              },
              suffixIcon: SvgPicture.asset(Assets.filterIcon),
              onTapOutside: (v) {
                FocusScope.of(context).unfocus();
              },
            ),
            Expanded(
              child: DisplaySearchStore(scrollController: _scrollController)),
          ],
        ),
      ),
    );
  }
}