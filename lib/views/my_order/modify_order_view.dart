import '../../export_all.dart';
import '../../utils/extension.dart';

class ModifyOrderView extends ConsumerStatefulWidget {
  final OrderModel orderData;
  const ModifyOrderView({super.key, required this.orderData});

  @override
  ConsumerState<ModifyOrderView> createState() => _ModifyOrderViewState();
}

class _ModifyOrderViewState extends ConsumerState<ModifyOrderView> {
  late OrderModel modifiedOrder;

  @override
  void initState() {
    super.initState();
    modifiedOrder = OrderModel(
      orderId: widget.orderData.orderId,
      userId: widget.orderData.userId,
      storeId: widget.orderData.storeId,
      addressId: widget.orderData.addressId,
      status: widget.orderData.status,
      totalAmount: widget.orderData.totalAmount,
      discountAmount: widget.orderData.discountAmount,
      finalAmount: widget.orderData.finalAmount,
      voucherCode: widget.orderData.voucherCode,
      notes: widget.orderData.notes,
      createdAt: widget.orderData.createdAt,
      updatedAt: widget.orderData.updatedAt,
      items: widget.orderData.items.map((item) => OrderItem(
        orderItemId: item.orderItemId,
        listingId: item.listingId,
        productId: item.productId,
        productName: item.productName,
        quantity: item.quantity,
        unitPrice: item.unitPrice,
        totalPrice: item.totalPrice,
        listingData: item.listingData,
      )).toList(),
      shippingAddress: widget.orderData.shippingAddress,
    );
  }

  void addQuantity(int index) {
    setState(() {
      modifiedOrder.items[index] = OrderItem(
        orderItemId: modifiedOrder.items[index].orderItemId,
        listingId: modifiedOrder.items[index].listingId,
        productId: modifiedOrder.items[index].productId,
        productName: modifiedOrder.items[index].productName,
        quantity: modifiedOrder.items[index].quantity + 1,
        unitPrice: modifiedOrder.items[index].unitPrice,
        totalPrice: (modifiedOrder.items[index].quantity + 1) * modifiedOrder.items[index].unitPrice,
        listingData: modifiedOrder.items[index].listingData,
      );
      modifiedOrder = OrderModel(
        orderId: modifiedOrder.orderId,
        userId: modifiedOrder.userId,
        storeId: modifiedOrder.storeId,
        addressId: modifiedOrder.addressId,
        status: modifiedOrder.status,
        totalAmount: modifiedOrder.items.fold(0, (sum, item) => sum + item.totalPrice),
        discountAmount: modifiedOrder.discountAmount,
        finalAmount: modifiedOrder.finalAmount,
        voucherCode: modifiedOrder.voucherCode,
        notes: modifiedOrder.notes,
        createdAt: modifiedOrder.createdAt,
        updatedAt: modifiedOrder.updatedAt,
        items: modifiedOrder.items,
        shippingAddress: modifiedOrder.shippingAddress,
      );
    });
  }

  void removeQuantity(int index) {
    if (modifiedOrder.items[index].quantity > 1) {
      setState(() {
        modifiedOrder.items[index] = OrderItem(
          orderItemId: modifiedOrder.items[index].orderItemId,
          listingId: modifiedOrder.items[index].listingId,
          productId: modifiedOrder.items[index].productId,
          productName: modifiedOrder.items[index].productName,
          quantity: modifiedOrder.items[index].quantity - 1,
          unitPrice: modifiedOrder.items[index].unitPrice,
          totalPrice: (modifiedOrder.items[index].quantity - 1) * modifiedOrder.items[index].unitPrice,
          listingData: modifiedOrder.items[index].listingData,
        );
        modifiedOrder = OrderModel(
          orderId: modifiedOrder.orderId,
          userId: modifiedOrder.userId,
          storeId: modifiedOrder.storeId,
          addressId: modifiedOrder.addressId,
          status: modifiedOrder.status,
          totalAmount: modifiedOrder.items.fold(0, (sum, item) => sum + item.totalPrice),
          discountAmount: modifiedOrder.discountAmount,
          finalAmount: modifiedOrder.finalAmount,
          voucherCode: modifiedOrder.voucherCode,
          notes: modifiedOrder.notes,
          createdAt: modifiedOrder.createdAt,
          updatedAt: modifiedOrder.updatedAt,
          items: modifiedOrder.items,
          shippingAddress: modifiedOrder.shippingAddress,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(
      showBottomButton: true,
      customBottomWidget: Consumer(
        builder: (ctx, ref,child) {
          final isLoad = ref.watch(orderProvider.select((e)=>e.updateOrderApiResponse.status)) == Status.loading;
          return Padding(
            padding: EdgeInsets.symmetric(
            horizontal: AppTheme.horizontalPadding
          ), child: CustomButtonWidget(
            isLoad: isLoad,
            title: "save", onPressed: (){
            final items = modifiedOrder.items.map((item) => {
          "listing_id": item.listingId,
          "quantity": item.quantity,
        }).toList();
        ref.read(orderProvider.notifier).updateOrder(orderId: modifiedOrder.orderId, items: items);
     
          }),);
        },
      ),
      title: "Modify Order",
      child: ListView(
        padding: EdgeInsets.all(AppTheme.horizontalPadding),
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = modifiedOrder.items[index];
              return Container(
            padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 15.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: Color.fromRGBO(243, 243, 243, 1),
            ),
            child: Row(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                DisplayNetworkImage(imageUrl: item.listingData.product?.image ?? "", width: 57.r, height: 73.r ,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "${item.productName} ",
                              style: context.textStyle.displayMedium,
                            ),
                            
                            // TextSpan(
                            //   text: " 20% Off",
                            //   style: context.textStyle.titleSmall!.copyWith(
                            //     color: AppColors.secondaryColor,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      8.ph,
                      Text.rich(
                        textAlign: TextAlign.end,
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "\$${item.unitPrice} ",
                              style: context.textStyle.displayMedium!.copyWith(
                                color: AppColors.secondaryColor,
                              ),
                            ),
                            // TextSpan(
                            //   text: "\$${0}",
                            //   style: context.textStyle.displayMedium!.copyWith(
                            //     decoration: TextDecoration.lineThrough,
                            //     color: Color.fromRGBO(91, 91, 91, 1),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      8.ph,
                     
                      if(item.listingData.listingType == "BEST_BY_PRODUCTS" && item.listingData.bestByDate != null)
                Text(
                  "Best By: ${Helper.selectDateFormat(item.listingData.bestByDate!)} ",
                  style: context.textStyle.bodySmall!.copyWith(
                    color: AppColors.primaryTextColor.withValues(alpha: 0.7),
                  ),
                ),
            
                      // 2.ph,
                    ],
                  ),
                ),
                Container(
                  // height: 30.h,
                  padding: EdgeInsets.all(5.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(30.r),
                      right: Radius.circular(30.r),
                    ),
                    border: Border.all(width: 1, color: AppColors.borderColor),
                  ),
                  child: Row(
                    spacing: 10,
                    children: [
                      GestureDetector(
                        onTap: () {
                          removeQuantity(index);
                        },
                        child: SvgPicture.asset(Assets.minusSquareIcon),
                      ),
                      Text("${item.quantity}", style: context.textStyle.displayMedium),
                      GestureDetector(
                        onTap: () {
                          if(item.quantity < item.listingData.quantity){
                            addQuantity(index);
                          }
                          else{
                            Helper.showMessage(AppRouter.navKey.currentState!.context, message: AppRouter.navKey.currentState!.context.tr('not_available_quantity_to_select'));
        return;
                          }
                          
                        },
                        child: SvgPicture.asset(Assets.plusSquareIcon),
                      ),
                    ],
                  ),
                ),
              ],
            ),
                      );
            },
           separatorBuilder: (context, index)=> 10.ph, itemCount: modifiedOrder.items.length),

         
          Text(
            "Order Summary",
            style: context.textStyle.bodyMedium!.copyWith(fontSize: 18.sp),
          ),
          Divider(),
          OrderDetailTitleWidget(
            title: "Item Total",
            value: "\$${modifiedOrder.totalAmount}",
          ),
          10.ph,
          OrderDetailTitleWidget(
            title: "Total",
            value: "\$${modifiedOrder.totalAmount}",
          ),
        ],
      ),
    );
  }
}
