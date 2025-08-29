import '../../utils/extension.dart';

import '../../export_all.dart';

class MyLocationView extends StatefulWidget {
  const MyLocationView({super.key});

  @override
  State<MyLocationView> createState() => _MyLocationViewState();
}

class _MyLocationViewState extends State<MyLocationView> {
  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(
      showBottomButton: true,
      customBottomButtonWidget:  Row(
                  spacing: 5,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add),
                    Text("ADD NEW LOCATION", style: context.textStyle.displayMedium!.copyWith(
                      color: Colors.white
                    ),)
                  ],
                ),
      title: "My Locations", child: ListView.separated(
      padding: EdgeInsets.symmetric(
        vertical: AppTheme.horizontalPadding
      ),
      itemBuilder: (context, index)=> ListTile(
        
        horizontalTitleGap: 1.0,
       
        // minTileHeight: 0.0,
        contentPadding:EdgeInsets.symmetric(
          horizontal: 10.r
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            Assets.locationIcon,
            // width: 24.r,
            // height: 24.r,
          ),
        ),
        title: Text(
          'Home',
          style: context.textStyle.headlineMedium,
          
        ),
        subtitle: Text(
          'ABC, Street Lorem Ipsum',
          style: context.textStyle.titleSmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: (){}, icon: Icon(Icons.edit, color: AppColors.secondaryColor,)),
            IconButton(onPressed: (){}, icon: Icon(Icons.delete, color: Color.fromRGBO(174, 27, 13, 1),)),
          ],
        ),
        onTap: () {
          // Handle tap
          AppRouter.customback(times: 2);

        },
      ),
      separatorBuilder: (context, index)=>const Divider(), itemCount: 5));
  }
}