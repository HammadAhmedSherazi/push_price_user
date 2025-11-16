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
import 'providers/notification_provider/notification_provider.dart';
// import 'firebase_options.dart';



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
      
      await Future.wait([
      NotificationService.initNotifications(),
      FirebaseService.firebaseTokenInitial(),
    ]);

    if (Platform.isIOS) {
      SecureStorageManager.sharedInstance.deletePreviousStorage();
    }

    initializeService(); // if safe

    // Initialize unread notification count
    // if (AppRouter.navKey.currentContext != null) {
    //   final container = ProviderScope.containerOf(AppRouter.navKey.currentContext!);
    //   container.read(notificationProvider.notifier).getUnreadNotificationCount();
    // }
    } catch (e) {
      if (Platform.isIOS) {
      SecureStorageManager.sharedInstance.deletePreviousStorage();
    }

    initializeService(); // if safe

    // Initialize unread notification count
    // if (AppRouter.navKey.currentContext != null) {
    //   final container = ProviderScope.containerOf(AppRouter.navKey.currentContext!);
    //   container.read(notificationProvider.notifier).getUnreadNotificationCount();
    // }
    }
  });
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
Future<bool> onIosBackgroundWrapper(ServiceInstance service) async {
  // For iOS, use onStart for background as well to ensure it works
  onStart(service);
  return true;
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  final hasToken = await SecureStorageManager.sharedInstance.hasToken();
  final user = await SecureStorageManager.sharedInstance.getUserData();
 
  
  // Start location tracking for iOS background

  // Note: iOS has strict limitations - background location may not work when app is completely killed
  
  // Recursive location fetch to prevent overlaps for iOS
  Future<void> performLocationUpdate() async {
    try {
      if (user != null) {
        final userData = UserDataModel.fromJson(jsonDecode(user));

        if (hasToken && userData.isTravelMode) {
          // Fetch current location with retry logic for iOS
          LocationDataModel? locationData;
          try {
            locationData = await GeolocatorService.geolocatorInstance
                .getCurrentLocation(skipPermissions: true)
                .timeout(const Duration(seconds: 15));
          } catch (e) {
            // Try to get last known position if current fails
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

          // Update profile if location changed
          if (userData.latitude != locationData.latitude ||
              userData.longitude != locationData.longitude) {
            await AuthProvider().updateProfile(userDataModel: userData.copyWith(latitude: locationData.latitude, longitude: locationData.longitude), onBackground: true);
          }
        }
      }
    } catch (e) {
      // Handle errors silently in background
    }

    // Schedule next update after 60 seconds
    Future.delayed(const Duration(seconds: 15), performLocationUpdate);
  }

  // Start the first update
  performLocationUpdate();
  
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Set the service as foreground immediately to avoid timeout
  service.invoke('setAsForeground');

  WidgetsFlutterBinding.ensureInitialized();

  

  // Note: Permissions should be requested in the foreground UI before starting the background service
  // Do not check permissions here as Geolocator.checkPermission() may return denied in background context

  // Periodic location fetch
  // Note: For testing, you can reduce the interval (e.g., Duration(seconds: 10))
  // In production, use a longer interval (e.g., 20-30 seconds) to save battery
  // Recursive location fetch to prevent overlaps
  // Note: Interval set to 60 seconds to reduce frequency and prevent ANR
  Future<void> performLocationUpdate() async {
    try {
      // Check if service is still running (works for both Android and iOS)
      bool isServiceRunning = false;
      if (service is AndroidServiceInstance) {
        isServiceRunning = await service.isForegroundService();
      } else {
        // iOS service is always running if we're in this callback
        isServiceRunning = true;
      }

      if (isServiceRunning) {
        // Re-check travel mode status on each iteration
        final user = await SecureStorageManager.sharedInstance.getUserData();
        if (user != null) {
          final userData = UserDataModel.fromJson(jsonDecode(user));

          if (userData.isTravelMode) {
            // Fetch current location
            final position = await GeolocatorService.geolocatorInstance
                .getCurrentLocation(skipPermissions: true);

            // Format location string for notification
            final locationString =
                'Lat: ${position.latitude.toStringAsFixed(6)}, Long: ${position.longitude.toStringAsFixed(6)}';

            // Update foreground notification with location (Android only)
            if (service is AndroidServiceInstance) {
              service.setForegroundNotificationInfo(
                title: "Travel Mode Active",
                content: locationString,
              );
            }

            // Update profile if location changed
            if (userData.latitude != position.latitude ||
                userData.longitude != position.longitude) {
              await AuthProvider().updateProfile(userDataModel: userData.copyWith(latitude: position.latitude, longitude: position.longitude), onBackground: true);
            }
          } else {
            // Travel mode is off, update notification (Android only)
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
      // Handle errors - update notification with error
      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
          title: "Location Error",
          content: "Error: ${e.toString()}",
        );
      }
    }

    // Schedule next update after 60 seconds
    Future.delayed(const Duration(seconds: 60), performLocationUpdate);
  }

  // Start the first update
  performLocationUpdate();
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
