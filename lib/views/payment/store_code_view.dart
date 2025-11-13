import '../../export_all.dart';
import '../../utils/extension.dart';

class StoreCodeView extends StatefulWidget {
  final int orderId;
  const StoreCodeView({super.key, required this.orderId});

  @override
  State<StoreCodeView> createState() => _StoreCodeViewState();
}

class _StoreCodeViewState extends State<StoreCodeView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController codeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(title: "Store Code", child: Form(
      key: formKey,
      child: ListView(
        padding: EdgeInsets.all(AppTheme.horizontalPadding),
        children: [
          TextFormField(
            controller: codeController,
            onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      validator: (value) => value?.validateGeneralField(fieldName: "Store Code", minStrLen: 3),
            decoration: InputDecoration(
              labelText: "Code",
              hintText: "Enter Store Code"
            ),
          ),
          30.ph,
          Consumer(
            builder: (context, ref, child) {
              final isLoad = ref.watch(orderProvider.select((e)=>e.payNowApiResponse.status)) == Status.loading;
              return CustomButtonWidget(
                isLoad: isLoad,
                title: "pay now", onPressed: (){ 
                  if(formKey.currentState!.validate()){
                  ref.read(orderProvider.notifier).payNow(orderId: widget.orderId, chainCode: codeController.text.trim());

                  }
            
          });
            },
          )
          
          
        ],
      ),
    ));
  }
}