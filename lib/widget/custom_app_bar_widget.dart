import 'package:push_price_user/utils/extension.dart';

import '../export_all.dart';

class CustomAppBarWidget extends StatelessWidget implements PreferredSize {
  final double  height;
  final String title;
  final List<Widget> children;

  const CustomAppBarWidget({super.key, required this.height, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(height),
        child: Container(
          padding: EdgeInsets.only(
            top: 40.r,
            left: AppTheme.horizontalPadding,
            right: AppTheme.horizontalPadding,
            bottom: 20.r
          ),
          width: double.infinity, height: double.infinity,

          decoration: BoxDecoration(
            color: Color.fromRGBO(230, 243, 253, 0.5),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(35.r)
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: context.screenwidth * 0.25,
                    child: Row(

                      children: [
                        GestureDetector(
                          onTap: (){
                            AppRouter.scaffoldkey.currentState!.openDrawer();
                          },
                          child: CircleAvatar(
                            backgroundColor: Color.fromRGBO(234, 241, 255, 0.6),
                            radius: 20.r,
                            child: SvgPicture.asset(Assets.menuNavIcon),
                          ),
                        ),
                      ],
                    ),
                  ),
               
                  Text(title,style: context.textStyle.displayMedium,),
                
                  SizedBox(
                    width: context.screenwidth * 0.25,
                    child: Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){
                            AppRouter.push(NotificationView());
                          },
                          child: CircleAvatar(
                            backgroundColor: Color.fromRGBO(234, 241, 255, 0.6),
                            radius: 20.r,
                            child: SvgPicture.asset(Assets.notificationIcon),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Color.fromRGBO(234, 241, 255, 0.6),
                          radius: 20.r,
                          child: SvgPicture.asset(Assets.addCartIcon),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ...children
             ],
          ),
          ),
      );
  }
  
 
  
  @override
 
  Size get preferredSize => Size.fromHeight(height);
  
  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();
}