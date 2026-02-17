import SwiftUI

struct RootView: View {
    
    private let container: AppContainer
    @StateObject private var router: RootRouter
    @State private var didStart = false
    
    init(container: AppContainer) {
        self.container = container
        _router = StateObject(wrappedValue: RootRouter(auth: container.authService))
    }
    
    var body: some View {
        
        Group {
            switch router.route {
            case .launch:
                LaunchView(
                    shouldAnimate: true,
                    onAppearAction: {
                        // optional: e.g. setup language
                    },
                    onFinished: {
                        router.enableRouting()
                    }
                )
                
            case .home:
                HomeView()
                
            case .onboarding:
                OnboardingView {
                    router.setHome()
                }
            }
        }
        .task {
            guard !didStart else { return }
            didStart = true
            await router.start()
        }
        .environment(\.authService, container.authService)
    }
}
