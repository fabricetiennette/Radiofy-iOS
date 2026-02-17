import SwiftUI

@main
struct RadiofyApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    private let container = AppContainer()

    var body: some Scene {
        WindowGroup {
            RootView(container: container)
        }
    }
}
