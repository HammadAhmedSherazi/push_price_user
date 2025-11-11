import '../../export_all.dart';
import '../../utils/extension.dart';

class MyOrderView extends ConsumerStatefulWidget {
  const MyOrderView({super.key});

  @override
  ConsumerState<MyOrderView> createState() => _MyOrderViewState();
}

class _MyOrderViewState extends ConsumerState<MyOrderView> with SingleTickerProviderStateMixin {
   late TabController tabController;
   final List<Widget> tabs = [
    Tab(text: "In Process",),
    Tab(text: "Completed",),
    Tab(text: "Cancelled",),
   ];
  @override
  void initState() {
    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    Future.microtask((){
      fetchOrder();
    });
    
    super.initState();

  }
  void fetchOrder(){
    ref.read(orderProvider.notifier).getOrders();
  }
  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);

    return CustomScreenTemplate(
      title: "My Orders", child: Column(
      children: [

        CustomTabBarWidget(tabController: tabController, tabs: tabs,),

        Expanded(child: AsyncStateHandler(
          status: orderState.getOrdersApiResponse.status,
          dataList: orderState.orders ?? [],
          itemBuilder: (context, index) {
            final filteredOrders = orderState.orders?.where((order) => order.status == setOrderStatus(tabController.index).name).toList() ?? [];
            return GestureDetector(
              onTap: () {
                AppRouter.push(OrderDetailView(orderId: filteredOrders[index].orderId));
              },
              child: OrderCardWidget(order: filteredOrders[index])
            );
          },
          onRetry: () => fetchOrder(),
          length: orderState.orders?.where((order) => order.status == setOrderStatus(tabController.index).name).length ?? 0
        ))
      ],
    ));
  }
}

class OrderCardWidget extends StatelessWidget {
  final OrderModel order;
  const OrderCardWidget({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
    padding: EdgeInsets.symmetric(
      vertical: 10.r,
      horizontal: 20.r
    ),

    decoration: AppTheme.productBoxDecoration,
    child: Row(
      spacing: 15,
      children: [
        Image.asset(Assets.store, width: 50.r,),
        Expanded(child: Column(
          spacing: 4,
          children: [
            Row(
              children: [
                Expanded(child: Text("Store Name",style: context.textStyle.displayMedium,)),
                Text("\$${order.finalAmount}", style: context.textStyle.titleSmall!.copyWith(
                  color: AppColors.secondaryColor
                ),)
              ],
            ),
             Row(
              children: [
                Expanded(child: Text("Order ID #${order.orderId}",style: context.textStyle.bodyMedium,)),
               TextButton(
                style: ButtonStyle(
                  padding: WidgetStatePropertyAll(EdgeInsets.zero),
                  visualDensity: VisualDensity(
                    vertical: -4.0,
                    horizontal: -4.0
                  )
                ),
                onPressed: (){}, child: Text("View Details", style: context.textStyle.bodyMedium!.copyWith(
                color: AppColors.primaryColor,
                decoration: TextDecoration.underline
               ),))
              ],
            )
          ],
        ))
      ],
    ),
            );
  }
}

OrderStatus setOrderStatus(int index){
  switch (index) {
    case 0:
      return OrderStatus.inProcess;
    case 1:
      return OrderStatus.completed;
    case 2:
      return OrderStatus.cancelled;
    default:
      return OrderStatus.inProcess;
  }
  
}
