import SwiftUI

struct RootView: View {
    
    private let container: AppContainer
    @StateObject private var router: RootRouter
    
    init(container: AppContainer) {
        self.container = container
        _router = StateObject(wrappedValue: RootRouter(auth: container.authService))
    }
    
    var body: some View {
        
        Group {
            switch router.route {
            case .launch:
                LaunchView(shouldAnimate: true,
                           onAppearAction: {
                    //  optional: e.g. setup language
                }, onFinished: {
                    Task { await router.start() }
                })
                
            case .home:
//                HomeView()
                Text("Home")
            case .onboarding:
                OnboardingView {
                    router.setHome()
                }
            }
        }
        .environment(\.authService, container.authService)
    }
}
