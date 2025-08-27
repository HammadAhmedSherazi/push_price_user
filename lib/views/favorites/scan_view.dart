import '../../utils/extension.dart';
import '../../export_all.dart';

class ScanView extends StatelessWidget {
  final bool isSignUp;
  const ScanView({super.key, required this.isSignUp });

  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(
      title: "Barcode",
      showBottomButton: true,
      bottomButtonText: "scan now",
      onButtonTap: (){
        AppRouter.push(ScanProductView(isSignUp: isSignUp,));
      },
      
      child: ListView(
        padding: EdgeInsets.all(AppTheme.horizontalPadding), children: [
          Container(
            height: context.screenheight * 0.42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: Color.fromRGBO(50, 50, 50, 1)
            ),
            child: SvgPicture.asset(Assets.scanIcon),
          ),
          Padding(padding: EdgeInsets.symmetric(
            vertical: 20.r,
            horizontal: 50.r
          ), child: Text("Align Barcode Within The Frame To Scan", textAlign: TextAlign.center, style: context.textStyle.displayMedium!.copyWith(
            fontSize: 16.sp
          ),),)

        ],),
    );
  }
}
