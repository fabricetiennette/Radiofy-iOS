
import Foundation
import Alamofire

protocol APIClientProtocol {
    func request<T: Decodable>(
        _ convertible: URLRequestConvertible,
        decoder: JSONDecoder
    ) async throws -> T
}

extension APIClientProtocol {
    func request<T: Decodable>(
        _ convertible: URLRequestConvertible,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> T {
        let dataTask = AF.request(convertible)
            .validate()
            .serializingDecodable(T.self, decoder: decoder)

        return try await dataTask.value
    }
}

