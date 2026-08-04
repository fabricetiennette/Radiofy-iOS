import Foundation
import SwiftData

@MainActor
final class StationRepository: StationRepositing {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Recents

    func recentStations(limit: Int) async throws -> [RadioStation] {
        var descriptor = FetchDescriptor<StationEntity>(
            predicate: #Predicate { $0.lastOpenedAt != nil },
            sortBy: [SortDescriptor(\.lastOpenedAt, order: .reverse)]
        )
        descriptor.fetchLimit = limit

        return try context.fetch(descriptor).map(\.domainStation)
    }

    func markOpened(_ station: RadioStation) async throws {
        let stationID = station.id
        let descriptor = FetchDescriptor<StationEntity>(
            predicate: #Predicate { $0.id == stationID }
        )

        if let existing = try context.fetch(descriptor).first {
            // The catalogue fields may have changed since it was first stored.
            existing.apply(station)
            existing.lastOpenedAt = .now
        } else {
            let entity = StationEntity(station: station)
            entity.lastOpenedAt = .now
            context.insert(entity)
        }

        try context.save()
    }

    func clearRecentStations() async throws {
        let descriptor = FetchDescriptor<StationEntity>(
            predicate: #Predicate { $0.lastOpenedAt != nil }
        )

        for entity in try context.fetch(descriptor) {
            if entity.isFavorite {
                // Forget that it was opened, but keep the station itself.
                entity.lastOpenedAt = nil
            } else {
                context.delete(entity)
            }
        }

        try context.save()
    }
}
