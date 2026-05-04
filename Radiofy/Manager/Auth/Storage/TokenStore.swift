import Foundation

/// Persists the refresh token securely (e.g., Keychain).
public protocol TokenStore {
    func readRefreshToken() -> String?
    func writeRefreshToken(_ token: String)
    func deleteRefreshToken()
}
