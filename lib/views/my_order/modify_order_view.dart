import 'package:push_price_user/utils/extension.dart';

import '../../export_all.dart';

class ModifyOrderView extends StatefulWidget {
  const ModifyOrderView({super.key});

  @override
  State<ModifyOrderView> createState() => _ModifyOrderViewState();
}

class _ModifyOrderViewState extends State<ModifyOrderView> {
  int quantity = 1;
  addQuantity(){
   
    setState(() {
       quantity++;
    });
  }
  removeQuantity(){
    if(quantity > 1){
      setState(() {
        quantity--;
    });
    }
    
  }
  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(
      showBottomButton: true,
      bottomButtonText: "save",
      onButtonTap: (){
        AppRouter.pushReplacement(OrderSuccessModifiedView());
      },
      title: "Modify Order", child: ListView(
      padding: EdgeInsets.all(AppTheme.horizontalPadding),
      children: [
        Container(
          // height: 90.h,
      padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 15.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: Color.fromRGBO(243, 243, 243, 1),
      ),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Image.asset(Assets.groceryBag, width: 57.w,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "ABC Product ",
                        style: context.textStyle.displayMedium,
                      ),
                      TextSpan(
                        text: " 20% Off",
                        style: context.textStyle.titleSmall!.copyWith(
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
            8.ph,
                Text.rich(
                      textAlign: TextAlign.end,
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "\$80 ",
                            style: context.textStyle.displayMedium!.copyWith(
                              color: AppColors.secondaryColor,
                            ),
                          ),
                          TextSpan(
                            text: "\$99.99",
                            style: context.textStyle.displayMedium!.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: Color.fromRGBO(91, 91, 91, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                 8.ph,   
                Text(
                  "Best By: April 25, 2025",
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
                          right: Radius.circular(30.r)
                        ),
                        border: Border.all(
                          width: 1,
                          color: AppColors.borderColor
                        )
                      ),
                      child: Row(
                        spacing: 10,
                        children: [
                          GestureDetector(
                            onTap: () {
                              removeQuantity();
                            },
                            child: SvgPicture.asset(Assets.minusSquareIcon)),
                          Text("$quantity", style: context.textStyle.displayMedium,),
                          GestureDetector(
                            onTap: (){
                              addQuantity();
                            },
                            child: SvgPicture.asset(Assets.plusSquareIcon)),
                        ],
                      ),
                    ),
                    
         
        ],
      ),
    ),
    10.ph,
           Text(
                "Order Summary",
                style: context.textStyle.bodyMedium!.copyWith(fontSize: 18.sp),
              ),
          Divider(),
          OrderDetailTitleWidget(
            title: "Item Total",
            value: "\$160.00" ,
          ),
          10.ph,
          OrderDetailTitleWidget(
            title: "Sales Tax",
            value: "\$0.00" ,
          ),
          10.ph,
          OrderDetailTitleWidget(
            title: "Total",
            value: "\$160.00" ,
          ),

  
      ],
    ));
  }
}