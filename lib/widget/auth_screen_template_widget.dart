import 'package:push_price_user/utils/extension.dart';

import '../export_all.dart';

class AuthScreenTemplateWidget extends StatelessWidget {
  final String title;
  final List<Widget> childrens;
  final Widget? bottomWidget;
  final VoidCallback ? onBackTap;
  
  const AuthScreenTemplateWidget({super.key, required this.title, this.bottomWidget, required this.childrens, this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return CustomScreenTemplate(
      onBackCall: onBackTap,
      title: title, showBottomButton: bottomWidget != null, customBottomWidget: bottomWidget, child: ListView(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.horizontalPadding,
        vertical: 20.r
      ),
      children: [
        Center(
          child: AppLogoWidget(),
        ),
        30.ph,
        ...childrens,
       
      ],
    ),);
  }
}


