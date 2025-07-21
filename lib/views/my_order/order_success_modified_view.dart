import 'package:push_price_user/utils/extension.dart';

import '../../export_all.dart';

class OrderSuccessModifiedView extends StatelessWidget {
  const OrderSuccessModifiedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.horizontalPadding
        ),
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(Assets.checkCircleIcon),
            Text("Thankyou!", style: context.textStyle.displayMedium!.copyWith(
              color: AppColors.secondaryColor
            ),),
            Text("Your Order Has Been Placed Successfully!", style: context.textStyle.displayMedium!.copyWith(
              fontSize: 16.sp
            ),),
            CustomButtonWidget(title: "view order", onPressed: (){
              AppRouter.back();
            }),
            CustomOutlineButtonWidget(title: "back to home", onPressed: (){
              AppRouter.customback(
                times: 4
              );
              
            })
          ],
        ),
      ),
    );
  }
}