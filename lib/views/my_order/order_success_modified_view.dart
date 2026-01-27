import '../../export_all.dart';
import '../../utils/extension.dart';

class OrderSuccessModifiedView extends StatelessWidget {
  final String message;
  final int? count;
  const OrderSuccessModifiedView({super.key, required this.message, this.count});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
              Text(context.tr("thankyou"), style: context.textStyle.displayMedium!.copyWith(
                color: AppColors.secondaryColor
              ),),
              Text(message, style: context.textStyle.displayMedium!.copyWith(
                fontSize: 16.sp
              ),),
              CustomButtonWidget(title: "view order", onPressed: (){
                if(count != null){
                  AppRouter.customback(times: 3);
                  AppRouter.push(MyOrderView());
                  
                }
                else{
                  AppRouter.customback(times: 2);
                  AppRouter.push(MyOrderView());
      
                }
                
              }),
              CustomOutlineButtonWidget(title: context.tr("back_to_home"), onPressed: (){
                AppRouter.customback(
                  times: message.contains("Modified")? 4 : count ?? 2
                );
                // AppRouter.pushAndRemoveUntil(NavigationView());
              })
            ],
          ),
        ),
      ),
    );
  }
}