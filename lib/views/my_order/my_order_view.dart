import '../../export_all.dart';
import '../../utils/extension.dart';

class MyOrderView extends ConsumerStatefulWidget {
  const MyOrderView({super.key});

  @override
  ConsumerState<MyOrderView> createState() => _MyOrderViewState();
}

class _MyOrderViewState extends ConsumerState<MyOrderView> with SingleTickerProviderStateMixin {
   late TabController tabController;
    final List<Widget> tabs  = [
    Tab(text: AppRouter.navKey.currentContext!.tr("in_process"),),
    Tab(text: AppRouter.navKey.currentContext!.tr("completed"),),
    Tab(text: AppRouter.navKey.currentContext!.tr("cancelled"),),
   ];
  @override
  void initState() {
    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      if (tabController.indexIsChanging) return; // Avoid unnecessary calls
      fetchOrder(tabController.index);
      

      // Fetch new chat list based on selected tab

    });
    Future.microtask((){
      fetchOrder(0);
    });
    
    super.initState();

  }
  
  void fetchOrder(int index){
    String type = getTabType(index);
    ref.read(orderProvider.notifier).getOrders(type: type);
  }
  String getTabType(int index){
    if(index == 0){
      return "IN_PROCESS";
    }
    else if(index == 1){
      return "COMPLETED";
    }
    else{
      return "CANCELLED";
    }
  }
  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);
    final orders = orderState.orders ?? [];

    return CustomScreenTemplate(
      title: context.tr("my_orders"), child: Column(
      children: [

        CustomTabBarWidget(tabController: tabController, tabs: tabs,),

        Expanded(child: AsyncStateHandler(
          status: orderState.getOrdersApiResponse.status,
          dataList: orders,
          itemBuilder: (context, index) {
            // final filteredOrders = orderState.orders?.where((order) => order.status == setOrderStatus(tabController.index).name).toList() ?? [];
            return OrderCardWidget(order: orders[index], fun: (){
              fetchOrder(tabController.index);
            },);
          },
          onRetry: () => fetchOrder(tabController.index),
        
          // orderState.orders?.where((order) => order.status == setOrderStatus(tabController.index).name).length ?? 0
        ))
      ],
    ));
  }
}

class OrderCardWidget extends StatelessWidget {
  final OrderModel order;
  final VoidCallback fun;
  const OrderCardWidget({
    super.key,
    required this.order,
    required this.fun
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        AppRouter.push(OrderDetailView(orderId: order.orderId));
      },
      child: Container(
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
                  Expanded(child: Text(order.store.storeName,style: context.textStyle.displayMedium, maxLines: 1,)),
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
                  onPressed: (){
                    
                  }, child: Text(context.tr("view_details"), style: context.textStyle.bodyMedium!.copyWith(
                  color: AppColors.primaryColor,
                  decoration: TextDecoration.underline
                 ),))
                ],
              )
            ],
          ))
        ],
      ),
              ),
    );
  }
}


