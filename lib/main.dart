import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:geolocator/geolocator.dart';
import 'package:push_price_user/firebase_options.dart';

import 'export_all.dart';
// import 'firebase_options.dart';
//sds

Timer? _locationTimer;


Future<void> performLocationUpdate(ServiceInstance service) async {
  try {
    bool isServiceRunning = false;

    if (service is AndroidServiceInstance) {
      isServiceRunning = await service.isForegroundService();
    } else {
      isServiceRunning = true; // iOS fallback
    }

    if (isServiceRunning) {
      final hasToken = await SecureStorageManager.sharedInstance.hasToken() ;
      final userJsonData = await SecureStorageManager.sharedInstance.getUserData();

      if (userJsonData != null) {
        final userData = UserDataModel.fromJson(jsonDecode(userJsonData));
   

        final shouldUpdate =  hasToken && userData.isTravelMode ;

        if (shouldUpdate) {
          LocationDataModel locationData;
          if (service is AndroidServiceInstance) {
            locationData = await GeolocatorService.geolocatorInstance
                .getCurrentLocation(skipPermissions: true);
          } else {
            // iOS logic with timeout and fallback
            try {
              locationData = await GeolocatorService.geolocatorInstance
                  .getCurrentLocation(skipPermissions: true)
                  .timeout(const Duration(seconds: 15));
            } catch (e) {
              Position? lastPosition = await Geolocator.getLastKnownPosition();
              if (lastPosition != null) {
                locationData = LocationDataModel(
                  latitude: lastPosition.latitude,
                  longitude: lastPosition.longitude,
                  addressLine1: '',
                  city: '',
                  state: '',
                  country: '',
                );
              } else {
                throw Exception('Unable to get location: ${e.toString()}');
              }
            }
          }

          final locationString =
              'Lat: ${locationData.latitude.toStringAsFixed(6)}, Long: ${locationData.longitude.toStringAsFixed(6)}';

          if (service is AndroidServiceInstance) {
            service.setForegroundNotificationInfo(
              title: "Travel Mode Active",
              content: locationString,
            );
          }

          await AuthProvider().updateProfile(
            userDataModel: userData.copyWith(
              latitude: locationData.latitude,
              longitude: locationData.longitude,
            ),
            onBackground: true,
          );
          // NotificationService.showNotification(title: "Test Notification", body: "testing....");
          // print("Update Location ${_locationTimer}");
        } else {
          if (service is AndroidServiceInstance) {
            service.setForegroundNotificationInfo(
              title: "Background Location Service",
              content: "Travel mode is off",
            );
          }
        }
      }
    }
  } catch (e) {
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "Location Error",
        content: "Error: $e",
      );
    }
    // For iOS, handle errors silently
  }
}

void startLocationUpdates(ServiceInstance service) {
  _locationTimer?.cancel();

  _locationTimer = Timer.periodic(
    const Duration(seconds: 15),
    (timer) => performLocationUpdate(service),
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferenceManager.init();
  Stripe.publishableKey = 'pk_test_qblFNYngBkEdjEZ16jxxoWSM';
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(child: MyApp()),
        );
  await Future.delayed(Duration(seconds: 1));
  // Run heavy stuff AFTER UI built
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    try {
     await  Future.wait([ NotificationService.initNotifications(),FirebaseService.firebaseTokenInitial()]);


    if (Platform.isIOS) {
      SecureStorageManager.sharedInstance.deletePreviousStorage();
    }

    // Request location permissions before starting background service
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.always) {
      await initializeService();
    }

    } catch (e) {
      if (Platform.isIOS) {
      SecureStorageManager.sharedInstance.deletePreviousStorage();
    }

    // Request location permissions before starting background service
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.always) {
      await initializeService();
    }
    }
  });
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: false,
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
Future<bool> onIosBackgroundWrapper(ServiceInstance service) async {
  // For iOS, use onStart for background as well to ensure it works
  onStart(service);
  return true;
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  


  // Start location tracking for iOS background

  // Note: iOS has strict limitations - background location may not work when app is completely killed

  startLocationUpdates(service,);

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Set the service as foreground immediately to avoid timeout
  service.invoke('setAsForeground');


 WidgetsFlutterBinding.ensureInitialized();
 // MUST RUN IMMEDIATELY — avoid FGS timeout
  if (service is AndroidServiceInstance) {
    service.setForegroundNotificationInfo(
      title: "Background Location Service",
      content: "Initializing...",
    );
  }

  // Optional but supported by plugin
  service.invoke('setAsForeground');
 

  startLocationUpdates(service);
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
      child: prefs.getStartedCheck() ? LoginView() : OnboardingView(),
    );
  }
}
