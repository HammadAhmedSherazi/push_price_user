import 'package:push_price_user/models/subscription_plan_data_model.dart';

import '../../export_all.dart';
import '../../utils/extension.dart';

class SubscriptionPlanView extends ConsumerStatefulWidget {
  final bool? isPro;
  const SubscriptionPlanView({super.key, this.isPro = false});

  @override
  ConsumerState<SubscriptionPlanView> createState() =>
      _SubscriptionPlanViewState();
}

class _SubscriptionPlanViewState extends ConsumerState<SubscriptionPlanView> {
  @override
  void initState() {
    super.initState();
    Future.microtask((){
      ref.read(authProvider.notifier).getSubscriptionPlan();
    });
  }
  @override
  Widget build(BuildContext context) {
    final response = ref.watch(
      authProvider.select((e) => e.subscriptionPlanApiRes),
    );
    final List<SubscriptionPlanModel?>? plans = response.data;
    final data = widget.isPro!  && response.status == Status.completed && plans![0]!.planType == "PRO"
        ? plans[0]!
        :response.status == Status.completed? plans![1] : null;
    String formatted = data != null ? data.price.toStringAsFixed(2): "00.00";
List<String> parts = formatted.split('.');

int whole = int.parse(parts[0]);   // 14
int decimal = int.parse(parts[1]); //
    return AsyncStateHandler(
      status: response.status,
      dataList: data == null ?[]: [""],
      itemBuilder: null,
      onRetry: () {},
      customSuccessWidget: CustomScreenTemplate(
        customBottomWidget: widget.isPro!
            ? Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.horizontalPadding,
                ),
                child: Row(
                  spacing: 20,
                  children: [
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, child) {
                          final isLoad = ref.watch(authProvider.select((e)=>e.subcribeNow.status)) == Status.loading;
                          return CustomButtonWidget(
                            title: "subscribe",
                            isLoad: isLoad,
                            onPressed: () {
                              ref.read(authProvider.notifier).subcribeNow(type: data!.planType);
                            },
                          );
                        }
                      ),
                    ),
                    Expanded(
                      child: CustomOutlineButtonWidget(
                        title: "not now",
                        onPressed: () {
                          AppRouter.push(SubscriptionPlanView());
                        },
                      ),
                    ),
                  ],
                ),
              )
            : null,
        showBottomButton: true,
        bottomButtonText: "next",
        onButtonTap: () {
          AppRouter.push(AddFavouriteView());
        },
        title: "Subscription",
        child: ListView(
          padding: EdgeInsets.all(AppTheme.horizontalPadding),
          children: [
            Center(
              child: Text(
                widget.isPro!
                    ? context.tr("push_price_pro")
                    : context.tr("push_price_free"),
                style: context.textStyle.displayMedium!.copyWith(
                  fontSize: 20.sp,
                ),
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
              child: Text(
                widget.isPro!
                    ? context.tr("people_usually_save_3x_the_subscription_fees")
                    : context.tr("people_usually_save_30_percent_on_grocery"),
                textAlign: TextAlign.center,
                style: context.textStyle.displayLarge!.copyWith(
                  fontSize: 18.sp,
                  color: Colors.white,
                ),
              ),
            ),
            20.ph,
            Text(
              widget.isPro!
                  ? context.tr("pro_perks")
                  : context.tr("free_perks"),
              style: context.textStyle.displayMedium!.copyWith(fontSize: 18.sp),
            ),
            15.ph,
            if(data != null)...[
              ...List.generate(data.benefits.length, (index) {
              final item = data.benefits[index];
              return DiscountLIstTitleWidget(
                icon: setIcon(item.title),
                title: item.title,
                subtitle: item.subtitle,
              );
            }),
            ],
            
            if(widget.isPro!)...[
              20.ph,
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.top,
                      child: Transform.translate(
                        offset: const Offset(
                          -10,
                          -70,
                        ), // adjust Y offset as needed
                        child: Text(
                          '\$',
                          style: context.textStyle.bodySmall!.copyWith(
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                    ),
                    TextSpan(
                      text: '$whole',
                      style: context.textStyle.headlineLarge!.copyWith(
                        fontSize: 80.sp,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    TextSpan(
                      text: '.$decimal',
                      style: context.textStyle.displayLarge!.copyWith(
                        fontSize: 25.sp,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    TextSpan(
                      text: '/${data?.billingPeriod}',
                      style: context.textStyle.displayLarge!.copyWith(
                        fontSize: 18.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
            ]
            ],
        ),
      ),
    );
  }
}

class DiscountLIstTitleWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  const DiscountLIstTitleWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.r),
      padding: EdgeInsets.symmetric(vertical: 5.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(width: 1, color: AppColors.borderColor),
      ),
      child: ListTile(
        leading: icon.contains(".png")
            ? Image.asset(icon, width: 42.r, height: 40.r)
            : SvgPicture.asset(icon, width: 42.r, height: 40.r),
        title: Text(title),
        subtitle: Text(subtitle),
        titleTextStyle: context.textStyle.displayMedium!.copyWith(
          fontSize: 18.sp,
        ),
        subtitleTextStyle: context.textStyle.bodyMedium!.copyWith(
          color: Color(0xff5B5B5B),
        ),
      ),
    );
  }
}

String setIcon(String key) {
  if (key.contains("discount") && key.contains("travelling")) {
    return Assets.travelDiscountIcon;
  } else if (key.contains("notified")) {
    return Assets.notificationAlertIcon;
  } else {
    return Assets.discountIcon;
  }
}
