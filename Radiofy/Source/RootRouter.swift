import SwiftUI

@MainActor
final class RootRouter: ObservableObject {
    
    enum Route {
        case launch
        case onboarding
        case home
    }
    
    @Published private(set) var route: Route = .launch
    
    private let auth: AuthServicing
    
    init(auth: AuthServicing) {
        self.auth = auth
    }
    
    func setHome() {
        route = .home
    }
    
    func setOnboarding() {
        route = .onboarding
    }
    
    func start() async {
        await auth.restoreSession()
        
        do {
            try await auth.refresh()
            _ = try await auth.me()
            setHome()
        } catch {
            setOnboarding()
        }
    }
}
