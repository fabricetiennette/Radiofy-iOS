import Foundation

enum AppConfig {
    static var apiBaseURL: URL {
        guard
            let value = Bundle.main.object(forInfoDictionaryKey: "RADIOFY_API_BASE_URL") as? String,
            let url = URL(string: value)
        else {
            fatalError("Missing or invalid RADIOFY_API_BASE_URL in Info.plist")
        }
        return url
    }
    
    static var apiVersion: String {
        (Bundle.main.object(forInfoDictionaryKey: "RADIOFY_API_VERSION") as? String) ?? "v1"
    }
}
