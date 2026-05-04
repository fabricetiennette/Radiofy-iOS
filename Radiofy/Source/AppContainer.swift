import Foundation

final class AppContainer {
    let authService: AuthServicing
    let healthService: HealthServicing
    
    init() {
        authService = AuthService(baseURL: AppConfig.apiBaseURL)
        healthService = HealthService(baseURL: AppConfig.apiBaseURL)
    }
}
