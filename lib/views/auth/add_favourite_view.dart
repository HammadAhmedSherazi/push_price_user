import '../../export_all.dart';

class AddFavouriteView extends StatelessWidget {
  const AddFavouriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(title: "My Favorites", child: Container  (
      padding: EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButtonWidget(title: "Add New Favorites", onPressed: (){
            AppRouter.push(SearchProductView(
              isSignUp: true,
            ));
          }, radius: 8.r,),
          CustomOutlineButtonWidget(title: "Not Now", onPressed: (){
            AppRouter.pushAndRemoveUntil(NavigationView());
          }, radius: 8.r,),
        ],
      ),
    ));
  }
}