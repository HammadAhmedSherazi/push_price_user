import 'package:push_price_user/utils/extension.dart';

import '../../export_all.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: 50.r,
          horizontal: AppTheme.horizontalPadding
        ),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          spacing: 10.h,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppLogoWidget(),

            Image.asset(Assets.onBoardingImage, width: double.infinity, height: 285.r , fit: BoxFit.cover,),
            RichText(
              textAlign: TextAlign.center,
  text: TextSpan(
    
    style: context.textStyle.displayMedium!.copyWith(
      fontSize: 32.sp,
      
    ),
    
    children: [
      TextSpan(text: "Let’s Find The "),
      TextSpan(
        text: "Best",
        style: context.textStyle.displayMedium!.copyWith(
          color: AppColors.secondaryColor,
          fontSize: 32.sp,
      
    ),
      ),
      TextSpan(text: " & "),
      TextSpan(
        text: "Healthy Grocery",
        style: context.textStyle.displayMedium!.copyWith(
          color: AppColors.secondaryColor,
          fontSize: 32.sp,
      
    ),
      ),
     
    ],
  ),
),
            Text("Lorem ipsum dolor sit amet consectetur adipiscing elit odio, mattis quam tortor taciti aenean luctus nullam enim, dui praesent ad dapibus tempus natoque.", style: context.textStyle.titleMedium, textAlign: TextAlign.center,),
            Spacer(),
            CustomButtonWidget(title: "GET STARTED", onPressed: (){
              AppRouter.pushReplacement(SelectLanguageView());
            })

          ],
        ),
      ) ,
    );
  }
}