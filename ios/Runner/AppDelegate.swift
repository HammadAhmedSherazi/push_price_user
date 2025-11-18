import Flutter
import UIKit
import CoreLocation
import GoogleMaps


@main
@objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate {
  var locationManager: CLLocationManager?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyBTalnRBkhFW6a81Wn17xDZZI8dDjcDJzA");
    
    // Configure CLLocationManager for background location updates (required for release builds)
    locationManager = CLLocationManager()
    locationManager?.delegate = self
    locationManager?.allowsBackgroundLocationUpdates = true
    locationManager?.pausesLocationUpdatesAutomatically = false
    locationManager?.requestAlwaysAuthorization()
    locationManager?.startUpdatingLocation()
//      if #available(iOS 10.0, *) {
//     UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
//     }
// func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//                      completionHandler([.alert, .badge, .sound])
//       }
  

    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
