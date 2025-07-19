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
        ],
      ),
     
    );
  }
}