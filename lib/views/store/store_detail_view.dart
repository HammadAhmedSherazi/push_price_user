import '../../export_all.dart';

class StoreDetailView extends StatelessWidget {
  final StoreDataModel storeData;

  const StoreDetailView({super.key, required this.storeData});

  @override
  Widget build(BuildContext context) {
    // final List<UserRatingDataModel> userRating = List.generate(4, (index)=> UserRatingDataModel(userName: "Sara Williams", userImage: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQn9zilY2Yu2hc19pDZFxgWDTUDy5DId7ITqA&s", rating: 4.0, description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit,  eiusmod tempor Lorem ipsum dolor sit amet, consectetur adipiscing elit,  eiusmod tempor i ", date: DateTime.now()));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(context.storeDetailAppBarHeight),
        child: Container(
          padding: EdgeInsets.only(
            left: context.pageHorizontalPadding,
            right: context.pageHorizontalPadding,
            bottom: 10.ih,
            top: MediaQuery.paddingOf(context).top + 8.ih,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryAppBarColor,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30.iw),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 40.iw,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomBackWidget(height: 24, width: 24),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 48.iw),
                      child: Text(
                        storeData.storeName,
                        style: context.textStyle.displayMedium!,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              10.ph,
              Image.asset(Assets.store, width: 70.iw),
              10.ph,
            ],
          ),
        ),
      ),
      body: ListView(
        padding: context.pagePadding,
        children: [
          Text(context.tr("store_information"), style: context.textStyle.displayMedium!.copyWith(
            fontSize: 16.sp
          ),),
          10.ph,
          StoreDetailTitleWidget(
            title: "Store Address",
            description: storeData.storeLocation ,
          ),
          StoreDetailTitleWidget(
            title: "Operational Hours",
            description: storeData.storeOperationalHours ,
          ),
          10.ph,
          // Row(
          //   children: [
          //      Text("Rating & Reviews", style: context.textStyle.displayMedium!.copyWith(
          //   fontSize: 16.sp
          // ),),
          // Spacer(),
          // Icon(Icons.star, color: Color(0xffFF901C),),
          // 5.pw,
          // Text("4.5", style: context.textStyle.bodyMedium!.copyWith(
          //   fontSize: 16.sp
          // ),)
          //   ],
          // ),
          // 10.ph,
//           ListView.separated(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemBuilder: (context, index) {
//               final data = userRating[index];
//               return Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 spacing: 20,
//               children: [
//                 UserProfileWidget(radius: 20.r, imageUrl: data.userImage, borderWidth: 1.3,),
//                 Expanded(child: Column(
//                   spacing: 5,
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(data.userName, style: context.textStyle.displayMedium,),
//                             Text('Today | 02:35 pm', style: context.textStyle.titleMedium,)
//                           ],
//                         )),
//                         RatingBarIndicator(
//     rating: data.rating,
//     itemBuilder: (context, index) => Icon(
//          Icons.star_rounded,
//          color: Color(0xffFF901C),
//     ),
//     itemCount: 5,
//     itemSize: 20.r,
//     direction: Axis.horizontal,
// ),
//                       ],
//                     ),
//                     Text(data.description, style: context.textStyle.titleMedium, maxLines: 3,)
//                   ],
//                 ))
//               ],
//             );
//             }, separatorBuilder: (context, index)=> Divider(), itemCount: userRating.length)
        
        ],
      ),
    );
  }
}

class StoreDetailTitleWidget extends StatelessWidget {
  final String title;
  final String description;
  const StoreDetailTitleWidget({
    super.key,
    required this.title,
    required this.description
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 5.r
      ),
      padding: EdgeInsets.only(
        bottom: 5.r
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(
          color: AppColors.borderColor
        ))
      ),
      child: Row(
        spacing: 20,
        children: [
          Text(title, style: context.textStyle.bodyMedium!.copyWith(
            color: Color(0xff5B5B5B)
          ),),
           Expanded(child: Text(description, style: context.textStyle.bodyMedium!,textAlign: TextAlign.end,maxLines: 1, overflow: TextOverflow.ellipsis,))
        ],
      ),
    );
  }
}