import UIKit
import Flutter
//import flutter_background_service // add this
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    /// add this
//    static func registerPlugins(with registry: FlutterPluginRegistry) {
//        GeneratedPluginRegistrant.register(with: registry)
//    }
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyCRrfbYY6rhh2qfMPo-My7y_gUfsl2eP14")
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
//    SwiftFlutterBackgroundServicePlugin.setPluginRegistrantCallback { registry in
//                AppDelegate.registerPlugins(with: registry)
//            }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
