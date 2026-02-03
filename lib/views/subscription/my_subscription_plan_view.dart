import '../../export_all.dart';
import '../../utils/extension.dart';

class MySubscriptionPlanView extends ConsumerStatefulWidget {
  const MySubscriptionPlanView({super.key});

  @override
  ConsumerState<MySubscriptionPlanView> createState() => _MySubscriptionPlanViewState();
}

class _MySubscriptionPlanViewState extends ConsumerState<MySubscriptionPlanView> {
  @override
  void initState() {
    super.initState();
    Future.microtask((){
      ref.read(authProvider.notifier).getMySubscriptionPlan();
    });
  }
  @override
  Widget build(BuildContext context) {
    final response = ref.watch(authProvider.select((e)=>e.mySubcribePlanRes));
    final isFreePlan = response.data != null && !response.data!.isPro;
    return CustomScreenTemplate(
      showBottomButton: isFreePlan,
      customBottomWidget: isFreePlan
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: AppTheme.horizontalPadding),
              child: CustomButtonWidget(
                title: context.tr("subscribe_to_pro"),
                onPressed: () {
                  AppRouter.push(SubscriptionPlanView(isPro: true,
                  ));
                },
              ),
            )
          : null,
      onButtonTap: () {},
      title: context.tr("subscription_and_savings"),
      child:  AsyncStateHandler(status: response.status, dataList: response.data != null?[""]: [], itemBuilder: null, onRetry: (){
        ref.read(authProvider.notifier).getMySubscriptionPlan();
      }, customSuccessWidget: response.data != null ? ListView(
        padding: EdgeInsets.all(AppTheme.horizontalPadding),
        children: [
          Center(
            child: Text(
              "Push Price ${response.data!.isPro ? "Pro": "Free"}" ,
              style: context.textStyle.displayMedium!.copyWith(fontSize: 20.sp),
            ),
          ),
          20.ph,
          // Container(
          //   // height:  80.h,
          //   padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 15.r),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(8.r),
          //     color: AppColors.secondaryColor,
          //   ),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //          "You’ve saved \$50 so far in this month"
          //            ,
          //         textAlign: TextAlign.center,
          //         style: context.textStyle.displayLarge!.copyWith(
          //           fontSize: 18.sp,
          //           color: Colors.white,
          //         ),
          //       ),
          //       Text(
          //          "That’s 3x of your monthly subscription fees!"
          //            ,
          //         textAlign: TextAlign.center,
          //         style: context.textStyle.bodyMedium!.copyWith(
                    
          //           color: Colors.white,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // 20.ph,
          Text(
           "Your ${response.data!.isPro ? "Pro": "Free"} Perks",
            style: context.textStyle.displayMedium!.copyWith(fontSize: 18.sp),
          ),
          15.ph,
          if(response.data != null)...[
             ...List.generate(response.data!.benefits.length, (index) {
              final item = response.data!.benefits[index];
              return DiscountLIstTitleWidget(
                icon: setIcon(item.title),
                title: item.title,
                subtitle: item.subtitle,
              );
            }),
          ],
          
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
              Text(context.tr("plan_information"), style: context.textStyle.displayMedium!.copyWith(
                fontSize: 16.sp
              ),)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.tr("price_plan"), style: context.textStyle.bodySmall,),
              Expanded(child: Text( response.data!.isPro?"\$${response.data?.price}/${response.data?.billingPeriod}" : "Free", style: context.textStyle.bodySmall, textAlign: TextAlign.end,)),
            ],
          ),
          if(response.data!.isPro)
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.tr("subscription_ends_on"), style: context.textStyle.bodySmall,),
              Expanded(child: Text(Helper.selectDateFormat(response.data?.expiresAt), style: context.textStyle.bodySmall,textAlign: TextAlign.end,)),
            ],
          ),
        ],
      ),
    ),
    //      Container(
    //   margin: EdgeInsets.only(bottom: 15.r),
    //   padding: EdgeInsets.symmetric(vertical: 15.r, horizontal: 10.r),
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(8.r),
    //     border: Border.all(width: 1, color: AppColors.borderColor),
    //   ),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Text(context.tr("terms_and_conditions"), style: context.textStyle.displayMedium,),
    //       SvgPicture.asset(Assets.forwardIcon)
    //     ],
    //   )
    // )

        ],
      ) : const SizedBox.shrink(),
   ));

  }
}