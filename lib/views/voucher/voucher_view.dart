import '../../export_all.dart';
import '../../utils/extension.dart';

class VoucherView extends StatelessWidget {
  const VoucherView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        ;
        final voucher = ref.watch(orderProvider.select((e)=>e.validateVoucherApiResponse.data));

        if (voucher == null) {
          return CustomScreenTemplate(
            title: context.tr("vouchers"),
            child: Center(
              child: Text(context.tr("no_voucher_available")),
            ),
          );
        }

        return CustomScreenTemplate(
          title: context.tr("vouchers"),
          child: ListView(
            padding: EdgeInsets.all(AppTheme.horizontalPadding),
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 15.r,
                  horizontal: 20.r
                ),
                decoration: AppTheme.boxDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        SvgPicture.asset(Assets.menuVoucherIcon, width: 40.r, height: 40.r,),
                        Expanded(
                          child: Text(
                            voucher.getDiscountDescription(context),
                            style: context.textStyle.displayMedium!.copyWith(
                              color: AppColors.secondaryColor,
                              fontSize: 18.sp
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.r,
                        vertical: 5.r
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(30.r),
                          right: Radius.circular(30.r)
                        ),
                        border: Border.all(
                          color: AppColors.borderColor,
                        )
                      ),
                      child: Text(
                        "${voucher.getMinimumSpend(context)} ${voucher.getExpiry(context)}",
                        style: context.textStyle.displaySmall,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
