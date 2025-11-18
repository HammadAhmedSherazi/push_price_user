import 'package:push_price_user/providers/favourite_provider/favourite_provider.dart';

import '../../export_all.dart';
import '../../utils/extension.dart';

class ScanView extends StatelessWidget {
  final bool isSignUp;
  const ScanView({super.key, required this.isSignUp });

  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(
      title: "Barcode",
      // showBottomButton: true,
      // bottomButtonText: "scan now",
     
      
      child: ListView(
        padding: EdgeInsets.all(AppTheme.horizontalPadding), children: [
          Consumer(
            builder: (context, ref, child) {
              final providerVM = ref.watch(favouriteProvider);
              return GestureDetector(
                onTap: ()async{
                  String? res = await SimpleBarcodeScanner.scanBarcode(
                      context,
                      cameraFace: CameraFace.back,
                      barcodeAppBar: const BarcodeAppBar(
                        appBarTitle: '',
                        centerTitle: false,
                        enableBackButton: true,
                        backButtonIcon: Icon(Icons.arrow_back_ios),
                      ),
                      isShowFlashIcon: true,
                      delayMillis: 100,
                      
                   
                    );
                   
                    if(providerVM.getProductByBarCodeApiResponse.status != Status.loading && res != null && res != "-1"){
                      if(!context.mounted) return;
                                Helper.showFullScreenLoader(context);
                                ref.read(favouriteProvider.notifier).getProductByBarCode(barcode: res, isSignup: isSignUp);
                              }
                },
                child: Container(
                  height: context.screenheight * 0.42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: Color.fromRGBO(50, 50, 50, 1)
                  ),
                  child: SvgPicture.asset(Assets.scanIcon),
                ),
              );
            }
          ),
          Padding(padding: EdgeInsets.symmetric(
            vertical: 20.r,
            horizontal: 50.r
          ), child: Text(context.tr("align_barcode_within_the_frame_to_scan"), textAlign: TextAlign.center, style: context.textStyle.displayMedium!.copyWith(
            fontSize: 16.sp
          ),),)

        ],),
    );
  }
}
