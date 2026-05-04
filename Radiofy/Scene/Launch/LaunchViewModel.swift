import Foundation

@MainActor
final class LaunchViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var hasError = false

    private let healthService: HealthServicing

    init(healthService: HealthServicing) {
        self.healthService = healthService
    }

    func pingRequest() async {
        hasError = false
        isLoading = true
        defer { isLoading = false }

        let isHealthy = await healthService.pingHealth()
        hasError = !isHealthy
//        hasError = true
    }
}
