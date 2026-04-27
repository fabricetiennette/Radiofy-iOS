import Foundation
import Alamofire

public final class HealthService: HealthServicing {
    private let baseURL: URL
    private let session: Session
    
    public init(baseURL: URL,
                session: Session = .default) {
        self.baseURL = baseURL
        self.session = session
    }
    
    @discardableResult
    public func pingHealth() async -> Bool {
        let url = baseURL.appendingPathComponent(HealthEndpoint.health.path)

        let response = await session
            .request(url, method: .get)
            .validate(statusCode: 200..<300)
            .serializingDecodable(HealthResponse.self)
            .response

        guard let health = response.value else {
            return false
        }

        return health.status.uppercased() == "UP"
    }
}
