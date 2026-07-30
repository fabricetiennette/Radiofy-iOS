import Foundation

@MainActor
final class LaunchViewModel: ObservableObject {

    // MARK: - Output / UI state

    @Published private(set) var state: LoadState = .idle

    var isLoading: Bool { state.isLoading }
    var hasError: Bool { state.errorMessage != nil }

    // MARK: - Dependencies

    private let healthService: HealthServicing

    init(healthService: HealthServicing) {
        self.healthService = healthService
    }

    // MARK: - Actions

    func pingRequest() async {
        state = .loading

        let isHealthy = await healthService.pingHealth()
        state = isHealthy ? .loaded : .failed(L10n.unknownError)
    }
}
