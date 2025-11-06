import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../export_all.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService _singleton = NotificationService._();
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static NotificationService get notificationInstance => _singleton;

  // Initialize both Firebase and local notifications for iOS and Android
  static Future<void> initNotifications() async {
    // Initialize local notifications
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

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        // Handle notification tap
      },
    );

    // Request permissions for Firebase Messaging
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
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
      provisional: true,
      sound: true,
    );

    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  // Handle background messages
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    await showNotification(
      title: message.notification?.title ?? 'Notification',
      body: message.notification?.body ?? '',
    );
  }

  // Unified method to show notifications
  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    String? imageUrl,
  }) async {
    AndroidNotificationDetails androidNotificationDetails;
    DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    if (imageUrl != null) {
      final String? filePath = await _downloadAndSaveImage(imageUrl, "notification_image.jpg");
      BigPictureStyleInformation? bigPictureStyle;

      if (filePath != null) {
        bigPictureStyle = BigPictureStyleInformation(
          FilePathAndroidBitmap(filePath),
          largeIcon: FilePathAndroidBitmap(filePath),
        );
      }

      androidNotificationDetails = AndroidNotificationDetails(
        "high_importance_channel",
        "High Importance Notifications",
        importance: Importance.high,
        priority: Priority.high,
        styleInformation: bigPictureStyle,
        ticker: "New Notification",
      );
    } else {
      androidNotificationDetails = const AndroidNotificationDetails(
        'default_channel',
        'Default Notifications',
        channelDescription: 'General notifications',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker',
        icon: '@mipmap/ic_launcher',
      );
    }

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Download and save image locally
  static Future<String?> _downloadAndSaveImage(String url, String fileName) async {
    try {
      final Directory directory = await getTemporaryDirectory();
      final String filePath = '${directory.path}/$fileName';

      final http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      }
    } catch (e) {
      // Handle error silently or log
    }
    return null;
  }
}
