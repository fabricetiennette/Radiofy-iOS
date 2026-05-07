import UIKit
import Firebase

final class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Configure third-party services.
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()

        return true
    }
}
