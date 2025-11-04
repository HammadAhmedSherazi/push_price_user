import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:push_price_user/firebase_options.dart';

import 'export_all.dart';
// import 'firebase_options.dart';



@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    ScreenUtil.ensureScreenSize(),
    SharedPreferenceManager.init(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    // initializeService(),
  ]);

  // Initialize Firebase Messaging
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseService.firebaseTokenInitial();
  // SecureStorageManager doesn't need initialization
   runApp(
    // Adding ProviderScope enables Riverpod for the entire project
    const ProviderScope(child: MyApp()),
  );
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'Background Location Service',
      initialNotificationContent: 'Fetching location...',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  await service.startService();
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Set the service as foreground immediately to avoid timeout
  service.invoke('setAsForeground');

  WidgetsFlutterBinding.ensureInitialized();

  // Ensure permission - only check, do not request in background
  // LocationPermission permission = await Geolocator.checkPermission();
  // if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
  //   // Cannot request permission in background, skip
  //   return;
  // }

  // Periodic location fetch
  Timer.periodic(const Duration(seconds: 20), (timer) async {
    // final position = await Geolocator.getCurrentPosition(
    //   locationSettings: const LocationSettings(
    //     accuracy: LocationAccuracy.high,
    //   ),
    // );

    // debugPrint(
    //     '📍 Background Location: ${position.latitude}, ${position.longitude}');

    // Show notification with location update
    await NotificationService.showNotification(
      title: 'Location Updated',
      body: 'Current location: Run Notification',
    );
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final prefs = SharedPreferenceManager.sharedInstance;
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
            bottom: false,
            minimum: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom
          ),
            child: MaterialApp(
              navigatorKey: AppRouter.navKey,
              localizationsDelegates: const [
                LocalizationService.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', ""), // English
                Locale('es', ""), // Spanish
                // Add more languages here
              ],
              locale: currentLocale,
              debugShowCheckedModeBanner: false,
              title: 'Push Price Store',
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
      child: prefs.getStartedCheck()?LoginView() :OnboardingView(),
    );
  }
}
