import Foundation

public protocol RadioServicing {
    func browseStations(
        countryCode: String?,
        tag: String?,
        limit: Int,
        offset: Int
    ) async throws -> [RadioStation]

    func searchStations(
        query: String,
        limit: Int,
        offset: Int
    ) async throws -> [RadioStation]

    /// Search terms to offer while the user types, most popular first.
    func suggestions(
        query: String,
        limit: Int
    ) async throws -> [String]

    func resolveStreamUrl(stationUuid: String) async throws -> URL
}
