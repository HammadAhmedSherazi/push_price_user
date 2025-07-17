import 'package:push_price_user/utils/extension.dart';

import '../export_all.dart';

class CustomScreenTemplate extends StatelessWidget {
  final String title;
  final VoidCallback ? onBackCall;
  final bool? showBottomButton;
  final String ? bottomButtonText;
  final Widget ? customBottomWidget;
  final VoidCallback ? onButtonTap;
  final Widget child;
  const CustomScreenTemplate({super.key, required this.title, this.bottomButtonText, this.customBottomWidget, this.showBottomButton = false, this.onBackCall, this.onButtonTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: (showBottomButton ?? false)? customBottomWidget ?? Padding(padding: EdgeInsets.all(AppTheme.horizontalPadding), child: CustomButtonWidget(title: bottomButtonText ?? "", onPressed: onButtonTap),) : null,
      appBar:AppBar(
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

      ),
      body: child,
    );
  }
}