import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
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
    initializeService(),
  ]);

  // Initialize Firebase Messaging
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
      onBackground: onIosBackgroundWrapper,
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
  
  // Initialize notification service for iOS background context
  const DarwinInitializationSettings darwinInitialization =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  
  const InitializationSettings initializationSettings = InitializationSettings(
    iOS: darwinInitialization,
  );
  
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  
  // Request notification permissions explicitly for iOS
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
  
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (payload) {},
  );
  
  // Send a test notification to verify service is running
  const DarwinNotificationDetails testNotificationDetails =
      DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    interruptionLevel: InterruptionLevel.active,
  );
  
  await flutterLocalNotificationsPlugin.show(
    999999,
    'Background Service Started',
    'Location tracking is now active',
    const NotificationDetails(iOS: testNotificationDetails),
  );
  
  // Start location tracking for iOS background
  // Note: iOS has strict limitations - background location may not work when app is completely killed
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    try {
      // Re-check travel mode status on each iteration
      final user = await SecureStorageManager.sharedInstance.getUserData();
      if (user != null) {
        final userData = UserDataModel.fromJson(jsonDecode(user));
        
        if (userData.isTravelMode) {
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
                address: '',
                city: '',
                state: '',
                country: '',
              );
            } else {
              throw Exception('Unable to get location: ${e.toString()}');
            }
          }

          // Format location string for notification
          final locationString =
              'Lat: ${locationData.latitude.toStringAsFixed(6)}, Long: ${locationData.longitude.toStringAsFixed(6)}';

          // Show notification with location for testing
          const DarwinNotificationDetails darwinNotificationDetails =
              DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            interruptionLevel: InterruptionLevel.active,
          );

          const NotificationDetails notificationDetails =
              NotificationDetails(iOS: darwinNotificationDetails);

          await flutterLocalNotificationsPlugin.show(
            DateTime.now().millisecondsSinceEpoch.remainder(100000),
            'Location Update',
            locationString,
            notificationDetails,
          );

          // Update profile if location changed
          if (userData.latitude != locationData.latitude ||
              userData.longitude != locationData.longitude) {
            // API call will be added here when ready
          }
        }
      }
    } catch (e) {
      // Show error notification with more details
      const DarwinNotificationDetails darwinNotificationDetails =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.active,
      );

      const NotificationDetails notificationDetails =
          NotificationDetails(iOS: darwinNotificationDetails);

      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        'Location Error',
        'Error: ${e.toString()}',
        notificationDetails,
      );
    }
  });
  
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Set the service as foreground immediately to avoid timeout
  service.invoke('setAsForeground');

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notification service for background context
  const AndroidInitializationSettings androidInitialization =
      AndroidInitializationSettings("@mipmap/ic_launcher");
  const DarwinInitializationSettings darwinInitialization =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitialization,
    iOS: darwinInitialization,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Request notification permissions explicitly for iOS (important for release builds)
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (payload) {},
  );

  // Send a test notification to verify service is running (for debugging)
  const DarwinNotificationDetails testNotificationDetails =
      DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    interruptionLevel: InterruptionLevel.active,
  );
  
  await flutterLocalNotificationsPlugin.show(
    999998,
    'Service Running',
    'Location tracking active',
    const NotificationDetails(iOS: testNotificationDetails),
  );

  // Note: Permissions should be requested in the foreground UI before starting the background service
  // Do not check permissions here as Geolocator.checkPermission() may return denied in background context

  // Periodic location fetch
  // Note: For testing, you can reduce the interval (e.g., Duration(seconds: 10))
  // In production, use a longer interval (e.g., 20-30 seconds) to save battery
  Timer.periodic(const Duration(seconds: 5), (timer) async {
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

            // Show notification with location for testing (works on both iOS and Android)
            const AndroidNotificationDetails androidNotificationDetails =
                AndroidNotificationDetails(
              'location_channel',
              'Location Updates',
              channelDescription: 'Notifications for location updates',
              importance: Importance.low,
              priority: Priority.low,
              ticker: 'ticker',
              icon: '@mipmap/ic_launcher',
            );

            const DarwinNotificationDetails darwinNotificationDetails =
                DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            );

            const NotificationDetails notificationDetails =
                NotificationDetails(
              android: androidNotificationDetails,
              iOS: darwinNotificationDetails,
            );

            await flutterLocalNotificationsPlugin.show(
              DateTime.now().millisecondsSinceEpoch.remainder(100000),
              'Location Update',
              locationString,
              notificationDetails,
            );

            // Update profile if location changed
            // TODO: Replace this with direct API call when ready
            // AuthProvider won't work in background isolate (needs Riverpod context)
            // Use MyHttpClient.instance.put(ApiEndpoints.updateProfile, {...}) directly
            if (userData.latitude != position.latitude ||
                userData.longitude != position.longitude) {
              // API call will be added here
              // Example:
              // await MyHttpClient.instance.put(
              //   ApiEndpoints.updateProfile,
              //   userData.copyWith(
              //     latitude: position.latitude,
              //     longitude: position.longitude,
              //   ).toJson(),
              // );
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
      
      // Show error notification for testing (works on both iOS and Android)
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'location_channel',
        'Location Updates',
        channelDescription: 'Notifications for location updates',
        importance: Importance.low,
        priority: Priority.low,
        ticker: 'ticker',
        icon: '@mipmap/ic_launcher',
      );

      const DarwinNotificationDetails darwinNotificationDetails =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails =
          NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        'Location Error',
        'Error: ${e.toString()}',
        notificationDetails,
      );
    }
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
      child: prefs.getStartedCheck() ? FutureBuilder<bool>(
        future: SecureStorageManager.sharedInstance.hasToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return snapshot.data == true ? NavigationView() : LoginView();
        },
      ) : OnboardingView(),
    );
  }
}
