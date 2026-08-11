import SwiftUI

/// Builds the Radio feature (SwiftUI) with its dependencies.
/// Keeps composition outside the view for a clean architecture.
struct RadioModule {
    let authService: AuthServicing
    let radioService: RadioServicing

    @MainActor
    func makeView() -> some View {
        let viewModel = RadioViewModel(authService: authService, radioService: radioService)
        return RadioView(viewModel: viewModel)
    }
}

#if DEBUG
/// Serves canned stations so previews never hit the network.
struct PreviewRadioService: RadioServicing {

    static let sampleStations: [RadioStation] = [
        ("Radio One Stereo", "Tanzania"), ("Radio Lac", "Switzerland"),
        ("Couleur 3", "Switzerland"), ("FIP", "France"),
        ("NTS Radio", "United Kingdom"), ("Worldwide FM", "United Kingdom")
    ].enumerated().map { index, station in
        RadioStation(
            id: "preview-\(index)",
            name: station.0,
            streamUrl: nil,
            imageUrl: nil,
            country: station.1,
            language: nil,
            tags: []
        )
    }

    func browseStations(countryCode: String?, tag: String?, limit: Int, offset: Int) async throws -> [RadioStation] {
        Array(Self.sampleStations.prefix(limit))
    }

    func searchStations(query: String, limit: Int, offset: Int) async throws -> [RadioStation] {
        Array(Self.sampleStations.prefix(limit))
    }

    /// Built from the query so previews show the typed part highlighted, which is
    /// the whole point of the suggestion row.
    func suggestions(query: String, limit: Int) async throws -> [String] {
        Array(["radio \(query)", "\(query) fm", "smooth \(query)"].prefix(limit))
    }

    func resolveStreamUrl(stationUuid: String) async throws -> URL {
        throw RadioServiceError.invalidStationUuid
    }
}

/// In-memory station store so previews never touch SwiftData.
/// Seed it with `recents:` to preview the populated list instead of the empty state.
@MainActor
final class PreviewStationRepository: StationRepositing {

    private var opened: [RadioStation]

    init(recents: [RadioStation] = []) {
        opened = recents
    }

    func recentStations(limit: Int) async throws -> [RadioStation] {
        Array(opened.prefix(limit))
    }

    func markOpened(_ station: RadioStation) async throws {
        opened.removeAll { $0.id == station.id }
        opened.insert(station, at: 0)
    }

    func clearRecentStations() async throws {
        opened.removeAll()
    }
}
#endif
