import Foundation

/// Local station store. Favourite methods land here at the next step, once the
/// backend owns them; today it only serves the recents.
///
/// `async` even though SwiftData answers synchronously on the main actor, so
/// moving the store onto a `ModelActor` later does not change this contract.
protocol StationRepositing {
    func recentStations(limit: Int) async throws -> [RadioStation]
    func markOpened(_ station: RadioStation) async throws
    func clearRecentStations() async throws
}
