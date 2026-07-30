import Foundation

public final class RadioService: RadioServicing {

    private let baseURL: URL
    private let urlSession: URLSession
    private let authSession: AuthSession
    private let decoder: JSONDecoder

    public init(
        baseURL: URL,
        urlSession: URLSession = .shared,
        authSession: AuthSession = AuthSession(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.baseURL = baseURL
        self.urlSession = urlSession
        self.authSession = authSession
        self.decoder = decoder
    }

    // MARK: - Stations

    public func browseStations(
        countryCode: String? = nil,
        tag: String? = nil,
        limit: Int = 30,
        offset: Int = 0
    ) async throws -> [RadioStation] {
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset))
        ]

        if let countryCode, !countryCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            queryItems.append(URLQueryItem(name: "countryCode", value: countryCode))
        }

        if let tag, !tag.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            queryItems.append(URLQueryItem(name: "tag", value: tag))
        }

        let dtos: [RadioStationDTO] = try await sendJSON(
            endpoint: .browse,
            queryItems: queryItems,
            authenticated: true
        )

        return dtos.map { $0.toDomain() }
    }

    public func searchStations(
        query: String,
        limit: Int = 20,
        offset: Int = 0
    ) async throws -> [RadioStation] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return [] }

        let queryItems = [
            URLQueryItem(name: "q", value: trimmedQuery),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset))
        ]

        let dtos: [RadioStationDTO] = try await sendJSON(
            endpoint: .search,
            queryItems: queryItems,
            authenticated: true
        )

        return dtos.map { $0.toDomain() }
    }

    public func resolveStreamUrl(stationUuid: String) async throws -> URL {
        let trimmedStationUuid = stationUuid.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedStationUuid.isEmpty else {
            throw RadioServiceError.invalidStationUuid
        }

        let dto: RadioStreamURLDTO = try await sendJSON(
            endpoint: .streamUrl(stationUuid: trimmedStationUuid),
            queryItems: [],
            authenticated: true
        )

        return try dto.toURL()
    }

    // MARK: - Internals

    private func sendJSON<T: Decodable>(
        endpoint: RadioEndpoint,
        queryItems: [URLQueryItem],
        authenticated: Bool
    ) async throws -> T {
        let (data, _) = try await sendRequest(
            endpoint: endpoint,
            queryItems: queryItems,
            authenticated: authenticated
        )

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw RadioServiceError.decodingFailed(error)
        }
    }

    @discardableResult
    private func sendRequest(
        endpoint: RadioEndpoint,
        queryItems: [URLQueryItem],
        authenticated: Bool
    ) async throws -> (Data, HTTPURLResponse) {
        var components = URLComponents(
            url: baseURL.appendingPathComponent(endpoint.path),
            resolvingAgainstBaseURL: false
        )
        components?.queryItems = queryItems.isEmpty ? nil : queryItems

        guard let url = components?.url else {
            throw RadioServiceError.invalidURL
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 20
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if authenticated {
            guard let accessToken = await authSession.accessToken else {
                throw RadioServiceError.notAuthenticated
            }

            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await urlSession.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw RadioServiceError.invalidResponse
        }

        guard (200..<300).contains(http.statusCode) else {
            let message = String(data: data, encoding: .utf8)
            throw RadioServiceError.server(status: http.statusCode, message: message)
        }

        return (data, http)
    }
}

public enum RadioServiceError: Error {
    case notAuthenticated
    case invalidURL
    case invalidResponse
    case server(status: Int, message: String?)
    case decodingFailed(Error)
    case invalidStationUuid
}
