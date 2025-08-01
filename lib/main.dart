import 'export_all.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  await ScreenUtil.ensureScreenSize();
  Stripe.publishableKey = "sk_test_BQokikJOvBiI2HlWgH4olfQ2";
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
    
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_ , child) {
        return Container(
          color: Colors.white,
          child: SafeArea(
            top: false,
            // bottom: false,
            // maintainBottomViewPadding: true,
            minimum: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom
            ),
            child: MaterialApp(
              navigatorKey: AppRouter.navKey,
              debugShowCheckedModeBanner: false,
              title: 'Push Price',
              theme: AppTheme.lightTheme,
              home: child,
            ),
          ),
        );
      },
      useInheritedMediaQuery: true,
      child: OnboardingView(),
    );
  }
}
