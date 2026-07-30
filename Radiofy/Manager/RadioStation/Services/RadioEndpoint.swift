public enum RadioEndpoint {
    case browse
    case search
    case streamUrl(stationUuid: String)
    
    private var apiVersion: String { AppConfig.apiVersion }

    var path: String {
        switch self {
        case .browse:
            return "/\(apiVersion)/radio/stations"

        case .search:
            return "/\(apiVersion)/radio/stations/search"

        case .streamUrl(let stationUuid):
            return "/\(apiVersion)/radio/stations/\(stationUuid)/stream-url"
        }
    }
}
