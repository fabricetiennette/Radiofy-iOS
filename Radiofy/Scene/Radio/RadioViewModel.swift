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
            featuredState = .failed(error.localizedDescription)
        }
    }
}
