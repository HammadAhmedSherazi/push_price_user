import '../../utils/extension.dart';

import '../../export_all.dart';

class VoucherApplyView extends StatelessWidget {
  const VoucherApplyView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(title: "Vouchers and Offers", child: ListView(
      padding: EdgeInsets.all(AppTheme.horizontalPadding),
      children: [
        TextFormField(
          onTapOutside: (event) {
  FocusScope.of(context).unfocus();
},
          decoration: InputDecoration(
            labelText: "Voucher",
            hintText: "Enter Voucher Code"
          ),
        ),
        30.ph,
        CustomButtonWidget(title: "apply", onPressed: (){ 
          AppRouter.pushReplacement(VoucherView());
        })
        
      ],
    ));
  }
}