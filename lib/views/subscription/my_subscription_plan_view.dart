import '../../export_all.dart';
import '../../utils/extension.dart';

class MySubscriptionPlanView extends StatefulWidget {
  const MySubscriptionPlanView({super.key});

  @override
  State<MySubscriptionPlanView> createState() => _MySubscriptionPlanViewState();
}

class _MySubscriptionPlanViewState extends State<MySubscriptionPlanView> {
  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(
     
      showBottomButton: true,
      bottomButtonText: "un-subscribe",
      onButtonTap: () {},
      title: "Subscription & Savings",
      child: ListView(
        padding: EdgeInsets.all(AppTheme.horizontalPadding),
        children: [
          Center(
            child: Text(
              "Push Price Pro" ,
              style: context.textStyle.displayMedium!.copyWith(fontSize: 20.sp),
            ),
          ),
          20.ph,
          Container(
            // height:  80.h,
            padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 15.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: AppColors.secondaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                   "You’ve saved \$50 so far in this month"
                     ,
                  textAlign: TextAlign.center,
                  style: context.textStyle.displayLarge!.copyWith(
                    fontSize: 18.sp,
                    color: Colors.white,
                  ),
                ),
                Text(
                   "That’s 3x of your monthly subscription fees!"
                     ,
                  textAlign: TextAlign.center,
                  style: context.textStyle.bodyMedium!.copyWith(
                    
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          20.ph,
          Text(
           "Your Pro Perks",
            style: context.textStyle.displayMedium!.copyWith(fontSize: 18.sp),
          ),
          15.ph,
          DiscountLIstTitleWidget(
            icon: Assets.discountIcon,
            title: "5% additional discount",
            subtitle: "Unlimited times",
          ),
          DiscountLIstTitleWidget(
            icon: Assets.notificationAlertIcon,
            title: "Get notified for discounts",
            subtitle:  "Unlimited times" ,
          ),
          DiscountLIstTitleWidget(
            icon: Assets.travelDiscountIcon,
            title: "5% additional discount",
            subtitle:  "Unlimited times" ,
          ),
          10.ph,
          Container(
      margin: EdgeInsets.only(bottom: 15.r),
      padding: EdgeInsets.symmetric(vertical: 15.r, horizontal: 10.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(width: 1, color: AppColors.borderColor),
      ),
      child: Column(
        spacing: 5.h,
        children: [
          Row(
            spacing: 15,
            children: [
              SvgPicture.asset(Assets.dollarSquareIcon),
              Text("Plan information", style: context.textStyle.displayMedium!.copyWith(
                fontSize: 16.sp
              ),)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.tr("price_plan"), style: context.textStyle.bodySmall,),
              Text(context.tr("price_per_month").replaceFirst("%s", "14.99"), style: context.textStyle.bodySmall,),
            ],
          ),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.tr("subscription_ends_on"), style: context.textStyle.bodySmall,),
              Text("April 25, 2025", style: context.textStyle.bodySmall,),
            ],
          ),
        ],
      ),
    ),
         Container(
      margin: EdgeInsets.only(bottom: 15.r),
      padding: EdgeInsets.symmetric(vertical: 15.r, horizontal: 10.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(width: 1, color: AppColors.borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(context.tr("terms_and_conditions"), style: context.textStyle.displayMedium,),
          SvgPicture.asset(Assets.forwardIcon)
        ],
      )
    )

        ],
      ),
    );

  }
}