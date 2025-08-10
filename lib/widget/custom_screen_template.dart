import 'package:push_price_user/utils/extension.dart';

import '../export_all.dart';

class CustomScreenTemplate extends StatelessWidget {
  final String title;
  final VoidCallback ? onBackCall;
  final bool? showBottomButton;
  final String ? bottomButtonText;
  final Widget ? customBottomButtonWidget;
  final Widget ? customBottomWidget;
  final VoidCallback ? onButtonTap;
  final Widget? actionWidget;
  final Widget child;
  const CustomScreenTemplate({super.key, required this.title, this.bottomButtonText, this.customBottomWidget, this.showBottomButton = false, this.onBackCall, this.onButtonTap, required this.child, this.actionWidget, this.customBottomButtonWidget});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      // maintainBottomViewPadding: true,
      minimum: EdgeInsets.only(
        bottom: 10.h
      ),
      child: Scaffold(
        // bottomSheet: (showBottomButton ?? false)? customBottomWidget ?? Padding(padding: EdgeInsets.all(AppTheme.horizontalPadding), child: CustomButtonWidget(title: bottomButtonText ?? "", onPressed: onButtonTap),) : null,
        
        appBar:AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(title, style: context.textStyle.labelMedium),
          elevation: 0.0,
          // leadingWidth: 24.r,
          leading: Padding(
            padding: const EdgeInsets.all(14.0),
            child: CustomBackWidget(
              onTap: onBackCall,
            ),
          ),
          actions: actionWidget != null ? [actionWidget!] : null,
      
        ),
        body: Column(
          children: [
            Expanded(child: child),
            20.ph,
            if( showBottomButton ?? false)...[
              customBottomWidget ?? Padding(padding: EdgeInsets.symmetric(
                horizontal: AppTheme.horizontalPadding
              ), child: CustomButtonWidget(title: bottomButtonText ?? "", onPressed: onButtonTap, child: customBottomButtonWidget,),)
            ],
            
       
          ],
        ),
      ),
    );
  }
}