import Foundation
import SwiftData

/// Local mirror of the stations the user has actually touched — opened or
/// favourited. This is not a copy of the catalogue: nothing is stored until the
/// user interacts with it, so the store stays small.
///
/// Kept separate from `RadioStation` on purpose. A `@Model` is an observed
/// reference type bound to a `ModelContext`; letting it reach the services and
/// views would tie the whole app to SwiftData and make previews and tests
/// require a container.
@Model
final class StationEntity {

    @Attribute(.unique) var id: String

    var name: String
    var streamUrl: URL?
    var imageUrl: URL?
    var country: String?
    var language: String?
    var tags: [String]

    /// Set when the user opens the station; drives the recents list.
    var lastOpenedAt: Date?

    /// Local mirror of the favourite flag the server will own.
    var isFavorite: Bool

    /// A local change the backend has not acknowledged yet. Unused until
    /// favourites sync exists, but present from v1 so adding sync later needs
    /// no schema migration.
    var pendingSync: Bool

    var updatedAt: Date

    init(
        id: String,
        name: String,
        streamUrl: URL? = nil,
        imageUrl: URL? = nil,
        country: String? = nil,
        language: String? = nil,
        tags: [String] = [],
        lastOpenedAt: Date? = nil,
        isFavorite: Bool = false,
        pendingSync: Bool = false,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.streamUrl = streamUrl
        self.imageUrl = imageUrl
        self.country = country
        self.language = language
        self.tags = tags
        self.lastOpenedAt = lastOpenedAt
        self.isFavorite = isFavorite
        self.pendingSync = pendingSync
        self.updatedAt = updatedAt
    }
}

// MARK: - Domain mapping

extension StationEntity {

    convenience init(station: RadioStation) {
        self.init(
            id: station.id,
            name: station.name,
            streamUrl: station.streamUrl,
            imageUrl: station.imageUrl,
            country: station.country,
            language: station.language,
            tags: station.tags
        )
    }

    /// Refreshes the catalogue fields without touching the local-only ones
    /// (`lastOpenedAt`, `isFavorite`, `pendingSync`).
    func apply(_ station: RadioStation) {
        name = station.name
        streamUrl = station.streamUrl
        imageUrl = station.imageUrl
        country = station.country
        language = station.language
        tags = station.tags
        updatedAt = .now
    }

    var domainStation: RadioStation {
        RadioStation(
            id: id,
            name: name,
            streamUrl: streamUrl,
            imageUrl: imageUrl,
            country: country,
            language: language,
            tags: tags
        )
    }
}
