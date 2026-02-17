import Foundation

final class AppContainer {
    let authService: AuthServicing
    
    init() {
        authService = AuthService(baseURL: AppConfig.apiBaseURL)
    }
}
