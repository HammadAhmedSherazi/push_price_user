import '../../export_all.dart';
import '../../utils/extension.dart';

class AllCategoryView extends ConsumerStatefulWidget {
  const AllCategoryView({super.key});

  @override
  ConsumerState<AllCategoryView> createState() => _AllCategoryViewState();
}

class _AllCategoryViewState extends ConsumerState<AllCategoryView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(homeProvider.notifier).getCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final categories = homeState.categories ?? [];
    return CustomScreenTemplate(
      title: "Categories",
      child: AsyncStateHandler(
        status: homeState.getCategoriesApiResponse.status,
        dataList: categories,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            onTap: () {
              AppRouter.push(CategoryStoreView(title: category.title, categoryId: category.id!,));
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
            leading: CircleAvatar(
              radius: 25.r,
              backgroundColor: Color.fromRGBO(238, 247, 254, 1),
              child: Padding(
                padding: EdgeInsets.all(4.r),
                child: DisplayNetworkImage(imageUrl: category.icon),
              ),
            ),
            title: Text(category.title, style: context.textStyle.displayMedium),
            trailing: Icon(Icons.arrow_forward_ios, size: 15.r),
          );
        },
        onRetry: () {
          ref.read(homeProvider.notifier).getCategories();
        },
      ),
    );
  }
}