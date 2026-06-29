import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:geolocator/geolocator.dart';
import 'package:push_price_user/firebase_options.dart';
import 'package:push_price_user/services/background_location_service.dart';
import 'package:push_price_user/services/travel_mode_background_handler.dart';

import 'export_all.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferenceManager.init();
  await EnvConfig.load();
  Stripe.publishableKey = EnvConfig.stripePublishableKey;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Configure background service early so it's ready when needed
  await _configureBackgroundService();
  runApp(const ProviderScope(child: MyApp()));
  // Run heavy stuff AFTER first frame — staggered to avoid blocking UI
  WidgetsBinding.instance.addPostFrameCallback((_) => _runPostLaunchTasks());
}

Future<void> _configureBackgroundService() async {
  await NotificationService.ensureForegroundServiceChannel();

  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: false,
      notificationChannelId: NotificationService.foregroundServiceChannelId,
      initialNotificationTitle: 'Background Location Service',
      initialNotificationContent: 'Fetching location...',
      foregroundServiceNotificationId: 888,
      foregroundServiceTypes: [AndroidForegroundType.location],
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

Future<void> _runPostLaunchTasks() async {
  try {
    await Future.wait([
      NotificationService.initNotifications(),
      FirebaseService.firebaseTokenInitial(),
    ]);
  } catch (_) {}
  // Request permissions and start background service
  await _requestPermissionsAndStartService();
}

Future<void> _requestPermissionsAndStartService() async {
  final userJsonData = await SecureStorageManager.sharedInstance.getUserData();
  if (userJsonData == null) return;

  final userData = await compute(parseUserJson, userJsonData);
  if (!userData.isTravelMode) return;

  final permission = await Geolocator.checkPermission();
  if (permission != LocationPermission.always) return;

  final service = FlutterBackgroundService();
  if (!await service.isRunning()) {
    await service.startService();
  }
}

/// Wrapper that calls restoreUserFromCache once when showing NavigationView after app open.
class _RestoreUserWrapper extends ConsumerStatefulWidget {
  const _RestoreUserWrapper({required this.child});

  final Widget child;

  @override
  ConsumerState<_RestoreUserWrapper> createState() => _RestoreUserWrapperState();
}

class _RestoreUserWrapperState extends ConsumerState<_RestoreUserWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).restoreUserFromCache();
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

Future<Widget> _getInitialChild(SharedPreferenceManager prefs) async {
  final token = await SecureStorageManager.sharedInstance.getToken();
  final hasValidToken = token != null && token.isNotEmpty;
  if (hasValidToken) {
    return _RestoreUserWrapper(child: const NavigationView());
  }
  if (prefs.getStartedCheck()) return const LoginView();
  return const OnboardingView();
}

/// Caches the initial route future so it's created once — avoids re-running on locale/rebuild.
class _InitialRouteLoader extends ConsumerStatefulWidget {
  const _InitialRouteLoader();

  @override
  ConsumerState<_InitialRouteLoader> createState() => _InitialRouteLoaderState();
}

class _InitialRouteLoaderState extends ConsumerState<_InitialRouteLoader> {
  late final Future<Widget> _initialRouteFuture;

  @override
  void initState() {
    super.initState();
    _initialRouteFuture =
        _getInitialChild(SharedPreferenceManager.sharedInstance);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _initialRouteFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data!;
      },
    );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ResponsiveScope.update(context);
    final currentLocale = ref.watch(localeProvider);
    final hasSystemBottomInset = MediaQuery.viewPaddingOf(context).bottom > 0;

    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        bottom: Platform.isIOS ? false : hasSystemBottomInset,
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
          ],
          locale: currentLocale,
          debugShowCheckedModeBanner: false,
          title: 'Push Price',
          theme: AppTheme.lightTheme,
          builder: (context, child) {
            ResponsiveScope.update(context);
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.noScaling,
              ),
              child: ResponsiveLayout(child: child!),
            );
          },
          home: const _InitialRouteLoader(),
        ),
      ),
    );
  }
}
