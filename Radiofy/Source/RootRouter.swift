import SwiftUI

@MainActor
final class RootRouter: ObservableObject {
    
    enum Route {
        case launch
        case onboarding
        case home
    }
    
    @Published var route: Route = .launch
    private var isRoutingEnabled = false
    private var pendingRoute: Route?
    
    private let auth: AuthServicing
    
    init(auth: AuthServicing) {
        self.auth = auth
    }
    
    func setHome() {
        setRoute(.home)
    }

    func setOnboarding() {
        setRoute(.onboarding)
    }

    func enableRouting() {
        isRoutingEnabled = true
        if let pendingRoute {
            route = pendingRoute
            self.pendingRoute = nil
        }
    }

    private func setRoute(_ newRoute: Route) {
        guard isRoutingEnabled else {
            pendingRoute = newRoute
            return
        }
        route = newRoute
    }
    
    func start() async {
        do {
            try await auth.resumeSession()
            _ = try await auth.me()
            setHome()
        } catch {
            await auth.logout()
            setOnboarding()
        }
    }
}
