import UIKit
import Flutter
import GoogleMaps
import Firebase
// import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    // Messaging.messaging().delegate = self
    GMSServices.provideAPIKey("AIzaSyAVeK4RdElr_vVnuKHvl3MYPrf_DsHQn-M")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  // // Handle FCM token refresh
  //   func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
  //       print("FCM Token: \(fcmToken ?? "")")
  //   }

  //   // Handle FCM messages
  //   func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
  //       print("Received data message: \(remoteMessage.appData)")
  //   }
}
