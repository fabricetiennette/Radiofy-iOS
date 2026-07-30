//
//  RadioModels.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 13.05.2026.
//  Copyright © 2026 Fabrice Etiennette. All rights reserved.
//

import Foundation

public struct RadioStation: Identifiable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let streamUrl: URL?
    public let imageUrl: URL?
    public let country: String?
    public let language: String?
    public let tags: [String]

    public init(
        id: String,
        name: String,
        streamUrl: URL?,
        imageUrl: URL?,
        country: String?,
        language: String?,
        tags: [String]
    ) {
        self.id = id
        self.name = name
        self.streamUrl = streamUrl
        self.imageUrl = imageUrl
        self.country = country
        self.language = language
        self.tags = tags
    }
}

public struct RadioStationDTO: Decodable, Sendable {
    public let id: String
    public let name: String
    public let streamUrl: String?
    public let imageUrl: String?
    public let country: String?
    public let language: String?
    public let tags: [String]?

    public func toDomain() -> RadioStation {
        RadioStation(
            id: id,
            name: name,
            streamUrl: streamUrl.flatMap(URL.init(string:)),
            imageUrl: imageUrl.flatMap(URL.init(string:)),
            country: country,
            language: language,
            tags: tags ?? []
        )
    }
}

public struct RadioStreamURLDTO: Decodable, Sendable {
    public let streamUrl: String

    public func toURL() throws -> URL {
        guard let url = URL(string: streamUrl) else {
            throw RadioModelError.invalidStreamURL
        }

        return url
    }
}

public enum RadioModelError: Error, Sendable {
    case invalidStreamURL
}
