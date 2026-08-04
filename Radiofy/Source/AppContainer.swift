import Foundation
import SwiftData

@MainActor
final class AppContainer {
    let authService: AuthServicing
    let healthService: HealthServicing
    let radioService: RadioServicing
    let stationRepository: StationRepositing

    private let modelContainer: ModelContainer

    init() {
        // Shared by every service that calls an authenticated endpoint: the access
        // token obtained at login lives in this actor, so AuthService and RadioService
        // must hold the same instance or the second one always sees a nil token.
        let authSession = AuthSession()

        authService = AuthService(baseURL: AppConfig.apiBaseURL, authSession: authSession)
        healthService = HealthService(baseURL: AppConfig.apiBaseURL)
        radioService = RadioService(baseURL: AppConfig.apiBaseURL, authSession: authSession)

        do {
            modelContainer = try ModelContainer(for: StationEntity.self)
        } catch {
            // Nothing sensible to fall back on: the store is created on first
            // launch and a failure here means the device cannot persist at all.
            fatalError("Could not create the SwiftData container: \(error)")
        }

        stationRepository = StationRepository(context: modelContainer.mainContext)
    }
}
