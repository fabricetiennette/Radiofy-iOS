import SwiftUI

@MainActor
final class RadioViewModel: ObservableObject {

    /// Tiles in the featured grid at the top of the screen.
    private static let featuredLimit = 6

    // MARK: - Output / UI state
    @Published private(set) var featuredStations: [RadioStation] = []
    @Published private(set) var featuredState: LoadState = .idle

    // MARK: - Dependencies
    private let authService: AuthServicing
    private let radioService: RadioServicing

    init(authService: AuthServicing, radioService: RadioServicing) {
        self.authService = authService
        self.radioService = radioService
    }

    // MARK: - Actions

    func loadFeaturedStations() async {
        guard featuredState != .loading else { return }
        featuredState = .loading

        do {
            featuredStations = try await radioService.browseStations(
                countryCode: nil,
                tag: nil,
                limit: Self.featuredLimit,
                offset: 0
            )
            featuredState = .loaded
        } catch {
            featuredStations = []
            featuredState = .failed(Self.message(for: error))
        }
    }

    private static func message(for error: Error) -> String {
        guard let radioError = error as? RadioServiceError else {
            return "Could not load stations."
        }

        switch radioError {
        case .notAuthenticated:
            return "Your session has expired. Please sign in again."
        case .server(let status, _):
            return "The server responded with \(status)."
        case .decodingFailed:
            return "Unexpected response from the server."
        case .invalidURL, .invalidResponse, .invalidStationUuid:
            return "Could not load stations."
        }
    }
}
