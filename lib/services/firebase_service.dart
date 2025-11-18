import 'package:firebase_messaging/firebase_messaging.dart';

import '../export_all.dart';
import '../providers/notification_provider/notification_provider.dart';

class FirebaseService {
  FirebaseService._();

  static final FirebaseService _singleton = FirebaseService._();

  static FirebaseService get firebaseInstance => _singleton;

  static  String fcmToken = ""; 

  //helper method to get token
  //CREATE AN INSTANCE OF FIREBASE MESSAGING
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static Future<void> firebaseTokenInitial() async {
      try {
        
        fcmToken = await firebaseMessaging.getToken() ?? "";
    debugPrint("Fcm Token - $fcmToken");
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
   
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );



    // fetch the FCM token for this device

    // firebaseMessaging.getInitialMessage();
    // firebaseMessaging.getNotificationSettings();
    // await FirebaseMessaging.instance.setAutoInitEnabled(true);

    //Message Listen from Firebase
    FirebaseMessaging.onMessage.listen((noti)async {
     handleBackgroundMessage(noti);
     // Update unread notification count when new message arrives
     if (AppRouter.navKey.currentContext != null) {
       final container = ProviderScope.containerOf(AppRouter.navKey.currentContext!);
       container.read(notificationProvider.notifier).getUnreadNotificationCount();
     }

      // NotificationServices.showNotitfication(noti);
    });

    // Handle when app is opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // debugPrint('A new onMessageOpenedApp event was published!');
      // Handle navigation or other actions here
      final int ? storeId = message.data['store_id'];
      final int? productId = message.data['product_id'];
      if(storeId != null && productId != null){
        AppRouter.push(StoreView(storeData: StoreDataModel(
          storeId: storeId
        ), productId: productId,));
      }
      
      NotificationService.handleBackgroundMessage(message); });
      } catch (e) {

        // fcmToken = await firebaseMessaging.getToken() ?? "";
        throw Exception(e); 
      }
    
  }


  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    NotificationService.handleBackgroundMessage(message);
  }
  // Future<void> showNotificationWithImage(String imageUrl,RemoteMessage message) async {
  //   NotificationService.showNotificationWithImage(imageUrl, message);
  // }
}
