import 'package:push_price_user/utils/extension.dart';

import '../../export_all.dart';

class AllCategoryView extends StatelessWidget {
  const AllCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CategoryDataModel> categories = [
      CategoryDataModel(title: "Fruits", icon: Assets.fruits),
      CategoryDataModel(title: "Vegtables", icon: Assets.vegetable),
      CategoryDataModel(title: "Meat", icon: Assets.meat),
      CategoryDataModel(title: "Sea Food", icon: Assets.seaFood),
      CategoryDataModel(title: "Groceries", icon: Assets.grocery),
    ];
    return CustomScreenTemplate(title: "Categories", child: ListView.separated(
      padding: EdgeInsets.all(AppTheme.horizontalPadding),
      itemBuilder: (context, index) {
      final category = categories[index];
      return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: 0.0
      ),
      
      leading: CircleAvatar(
                        radius: 25.r,
                        backgroundColor: Color.fromRGBO(238, 247, 254, 1),
                        child: Padding(
                          padding: EdgeInsets.all(4.r),
                          child: Image.asset(category.icon),
                        ),
                      ),
      title: Text(category.title, style: context.textStyle.displayMedium,),
      trailing: Icon(Icons.arrow_forward_ios, size: 15.r,),
    );
    }, separatorBuilder: (context, index)=> 10.ph, itemCount: categories.length));
  }
}