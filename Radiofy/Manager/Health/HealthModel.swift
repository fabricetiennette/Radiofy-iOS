import Foundation

// MARK: - Responses

public struct HealthResponse: Decodable, Equatable {
    public let groups: [String]
    public let status: String
}
