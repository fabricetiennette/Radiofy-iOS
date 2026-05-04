import UIKit
import Firebase
import IQKeyboardManagerSwift

final class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Configure third-party services.
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        // Enable keyboard management for legacy UIKit screens.
        IQKeyboardManager.shared.enable = true

        return true
    }
}
