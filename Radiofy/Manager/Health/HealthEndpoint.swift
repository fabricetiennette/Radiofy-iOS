import Foundation

public enum HealthEndpoint {
    case health

    var path: String {
        switch self {
        case .health:
            return "actuator/health"
        }
    }
}
