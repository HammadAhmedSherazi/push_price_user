import '../../export_all.dart';
import '../../utils/extension.dart';

class StoreCodeView extends StatelessWidget {
  const StoreCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(title: "Store Code", child: ListView(
      padding: EdgeInsets.all(AppTheme.horizontalPadding),
      children: [
        TextFormField(
          onTapOutside: (event) {
  FocusScope.of(context).unfocus();
},
          decoration: InputDecoration(
            labelText: "Code",
            hintText: "Enter Store Code"
          ),
        ),
        30.ph,
        CustomButtonWidget(title: "pay now", onPressed: (){ 
          AppRouter.push(OrderDetailView(orderId: 1, afterPayment: true,));
        })
        
      ],
    ));
  }
}