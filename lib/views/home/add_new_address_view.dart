import '../../export_all.dart';

class AddNewAddressView extends StatefulWidget {
  const AddNewAddressView({super.key});

  @override
  State<AddNewAddressView> createState() => _AddNewAddressViewState();
}

class _AddNewAddressViewState extends State<AddNewAddressView> {
  final TextEditingController searchTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(title: "Location", child: Padding(
      padding:  EdgeInsets.all(AppTheme.horizontalPadding),
      child: Column(
        spacing: 10,
        children: [
          CustomSearchBarWidget(hintText: "Enter an address", controller: searchTextController, onChanged: (p0) {
            setState(() {
      
            });
          },),
          if(searchTextController.text != "")
          Expanded(child: ListView.separated(itemBuilder: (context, index)=>ListTile(
            onTap: (){
              AppRouter.back();
            },
            horizontalTitleGap: 1.0,
            leading: SvgPicture.asset(Assets.locationIcon),
            title: Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry."),
          ), separatorBuilder: (context, index)=>Divider(), itemCount: 5))
        ],
      ),
    ));
  }
}