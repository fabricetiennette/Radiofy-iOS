import Foundation

final class AppContainer {
    let authService: AuthServicing
    let healthService: HealthServicing
    let radioService: RadioServicing

    init() {
        // Shared by every service that calls an authenticated endpoint: the access
        // token obtained at login lives in this actor, so AuthService and RadioService
        // must hold the same instance or the second one always sees a nil token.
        let authSession = AuthSession()

        authService = AuthService(baseURL: AppConfig.apiBaseURL, authSession: authSession)
        healthService = HealthService(baseURL: AppConfig.apiBaseURL)
        radioService = RadioService(baseURL: AppConfig.apiBaseURL, authSession: authSession)
    }
}
