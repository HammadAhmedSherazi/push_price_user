import '../../export_all.dart';
import '../../utils/extension.dart';

class OrderDetailView extends ConsumerStatefulWidget {
  final int orderId;
  final bool? afterPayment;
  const OrderDetailView({super.key, required this.orderId, this.afterPayment = false});

  @override
  ConsumerState<OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends ConsumerState<OrderDetailView> {
  void showReasonDialog(BuildContext context) {
  int selectedIndex = 0;
  List<String> reasons = [
    "Product not available",
    "Lorem ipsum dolor sit amet consectetur.",
    "Lorem ipsum dolor sit amet consectetur.",
  ];

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder( // To manage state in dialog
        builder: (context, setState) {
          return Dialog(
            backgroundColor: const Color(0xFFF1F6FA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Padding(
              padding:  EdgeInsets.symmetric(
                horizontal: AppTheme.horizontalPadding,
                vertical: 25.r
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Reason",
                    style: context.textStyle.bodyMedium!.copyWith(
                      fontSize: 18.sp
                    ),
                  ),
                  20.ph,

                  // Radio List
                  RadioGroup<int>(
                    groupValue: selectedIndex,
                    onChanged: (value) => setState(() => selectedIndex = value!),
                    child: Column(
                      children: List.generate(reasons.length, (index) {
                        return Column(
                          children: [
                            Radio<int>(
                              value: index,
                              activeColor: AppColors.secondaryColor,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
                            ),
                            Text(reasons[index], style: context.textStyle.displayMedium,),
                            if (index != reasons.length - 1)
                              Divider(height: 1,),
                          ],
                        );
                      }),
                    ),
                  ),

                  20.ph,

                  // Next Button
                  Consumer(
                    builder: (context, ref, child) {
                      final isLoad = ref.watch(orderProvider.select((e)=>e.cancelOrderApiResponse.status)) == Status.loading;
                      return  CustomButtonWidget(
                        isLoad: isLoad,
                        title: "next", onPressed: (){
                          ref.read(orderProvider.notifier).cancelOrder(orderId: widget.orderId);
                  });
                    },
                  )
                 
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
  @override
  void initState() {
    super.initState();
    Future.microtask((){
      ref.read(orderProvider.notifier).getOrderDetail(orderId: widget.orderId);
    });
  }
  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);
    final order = orderState.orderDetail;
   
    return CustomScreenTemplate(
      title: "Order details",
      bottomButtonText:  widget.afterPayment!?"back to home" : null,
      onButtonTap: (){
        AppRouter.customback(times: 6);
      },
      showBottomButton: orderState.orderDetail?.status == "IN_PROCESS" && orderState.getOrderDetailApiResponse.status == Status.completed || widget.afterPayment!,
      customBottomWidget: orderState.orderDetail?.status == "IN_PROCESS" && orderState.getOrderDetailApiResponse.status == Status.completed?
      Padding(padding: EdgeInsets.all(AppTheme.horizontalPadding), child: Column(
        spacing: 15,
        children: [
          CustomOutlineButtonWidget(title: "modify order", onPressed: (){
            AppRouter.push(ModifyOrderView(
              orderData: orderState.orderDetail!,
            ));
          }),
          CustomButtonWidget(title: "make payment", onPressed: (){
            AppRouter.push(StoreCodeView());
          }),
        ],
      ),) : null,
      actionWidget: orderState.orderDetail?.status == "IN_PROCESS" && orderState.getOrderDetailApiResponse.status == Status.completed
          ? Row(
              children: [
                TextButton(
                  onPressed: () {
                    showReasonDialog(context);
                  },
                  style: ButtonStyle(
                    visualDensity: VisualDensity(
                      horizontal: -4.0,
                      vertical: -4.0,
                    ),
                    padding: WidgetStatePropertyAll(EdgeInsets.zero),
                  ),
                  child: Text(
                    "Cancel Order",
                    style: context.textStyle.displayMedium!.copyWith(
                      color: AppColors.primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                20.pw,
              ],
            )
          : null,
      child: AsyncStateHandler(
        status: orderState.getOrderDetailApiResponse.status,
        dataList: orderState.orderDetail != null ? [orderState.orderDetail!] : [],
        itemBuilder: null,
        customSuccessWidget: 
        order != null ? ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(AppTheme.horizontalPadding),
            children: [
              Text(
                "Order Details",
                style: context.textStyle.bodyMedium!.copyWith(fontSize: 18.sp),
              ),
              10.ph,
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = orderState.orderDetail!.items[index];
                  return OrderItemCardWidget(order: item);
                }, separatorBuilder: (context, index)=> 5.ph, itemCount: orderState.orderDetail!.items.length),
              5.ph,
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    
                    setTitle(order.status),
                    style: context.textStyle.bodyMedium!.copyWith(fontSize: 18.sp),
                  ),
                  // Text("Today 3:45pm", style: context.textStyle.bodySmall,)
                ],
              ),
              Divider(),
              OrderDetailTitleWidget(
                title: "Order ID",
                value: "#${order!.orderId}" ,
              ),
              10.ph,
              OrderDetailTitleWidget(
                title: "Date",
                value: "${order.createdAt.month}/${order.createdAt.day}/${order.createdAt.year}" ,
              ),
              10.ph,
              OrderDetailTitleWidget(
                title: "Total",
                value: "\$${order.finalAmount}" ,
              ),
              if(order.status == "COMPLETED")...[
                30.verticalSpace,
              Center(
                child: Column(
                  spacing: 10,
                  children: [
                    SvgPicture.asset(Assets.checkCircleIcon, width: 60.r,),
                    Container(
                      width: 75.w,
                      height: 35.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor
                      ),
                      child: Text("PAID", style: context.textStyle.headlineMedium!.copyWith(
                        color: Colors.white,
                        fontSize: 16.sp
                      ),),
                    )
                  ],
                ),
              )
              ]

            ],
          )
       : null,
        onRetry: () => ref.read(orderProvider.notifier).getOrderDetail(orderId: widget.orderId),
      ),
    );
  }
}

String setTitle(String status){
  switch (status) {
    case "IN_PROCESS":
      return "Order In-Process";
    case "COMPLETED":
      return "Order Completed";
    case "CANCELLED":
      return "Order Cancelled";   
    default:
      return "";
   
  }
}

class OrderDetailTitleWidget extends StatelessWidget {
  final String title;
  final String value;
  const OrderDetailTitleWidget({
    super.key,
    required this.title,
    required this.value
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 13,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,style: context.textStyle.bodyMedium!.copyWith(
              color: Color.fromRGBO(91, 91, 91, 1)
            ),),
            Text(value, style: context.textStyle.displayMedium,)
          ],
        ),
        SizedBox(
      width: double.infinity,
      height: 1,
      child: CustomPaint(
        painter: DottedLinePainter(),
      ),
    ),
      ],
    );
  }
}

class OrderItemCardWidget extends StatelessWidget {
  final OrderItem order;
  const OrderItemCardWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 3.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: Color.fromRGBO(243, 243, 243, 1),
      ),
      child: Row(
        spacing: 10,
        children: [
          Image.asset(Assets.groceryBag, width: 50.w, height: 70.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  maxLines: 1,
                  TextSpan(
                    
                    children: [
                      TextSpan(
                        text: order.productName,
                        style: context.textStyle.displayMedium,
                        
                      ),
                    ],
                  ),
                ),
                3.ph,
                if(order.listingData.listingType == "BEST_BY_PRODUCTS" && order.listingData.bestByDate != null)
                Text(
                  "Best By: ${Helper.selectDateFormat(order.listingData.bestByDate!)} ",
                  style: context.textStyle.bodySmall!.copyWith(
                    color: AppColors.primaryTextColor.withValues(alpha: 0.7),
                  ),
                ),
                10.ph,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Quantity: ${order.quantity}",
                      style: context.textStyle.displayMedium!.copyWith(
                        color: Color.fromRGBO(91, 91, 91, 1),
                      ),
                    ),
                    Text.rich(
                      textAlign: TextAlign.end,
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "\$${order.unitPrice * order.quantity}",
                            style: context.textStyle.displayMedium!.copyWith(
                              color: AppColors.secondaryColor,
                            ),
                            
                          ),
                          // if(order.listingData.)
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
