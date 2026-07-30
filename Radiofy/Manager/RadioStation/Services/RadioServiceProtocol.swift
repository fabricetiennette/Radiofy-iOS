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

    func resolveStreamUrl(stationUuid: String) async throws -> URL
}
