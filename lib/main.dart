import 'package:flutter/services.dart';

import 'export_all.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  await ScreenUtil.ensureScreenSize();
  
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
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: const TextScaler.linear(1.0),
                  ),
                  child: child!, 
                );
              },

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
