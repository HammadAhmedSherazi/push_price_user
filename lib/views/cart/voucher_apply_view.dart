import '../../export_all.dart';
import '../../utils/extension.dart';

class VoucherApplyView extends StatefulWidget {
  final num totalAmount;
  const VoucherApplyView({super.key, required this.totalAmount});

  @override
  State<VoucherApplyView> createState() => _VoucherApplyViewState();
}

class _VoucherApplyViewState extends State<VoucherApplyView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController voucherController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(
      title: "Vouchers and Offers",
      child: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(AppTheme.horizontalPadding),
          children: [
            TextFormField(
              controller: voucherController,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a voucher code';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "Voucher",
                hintText: "Enter Voucher Code",
              ),
            ),
            30.ph,
            Consumer(
              builder: (context, ref, child) {
                final isLoad =
                    ref.watch(
                      orderProvider.select(
                        (e) => e.validateVoucherApiResponse.status,
                      ),
                    ) ==
                    Status.loading;

                return CustomButtonWidget(
                  isLoad: isLoad,
                  title: "apply",
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      ref
                          .read(orderProvider.notifier)
                          .validateVoucher(
                            voucherCode: voucherController.text,
                            totalAmount: widget.totalAmount,
                          );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
