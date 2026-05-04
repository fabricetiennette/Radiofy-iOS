import Foundation

/// Stores authentication tokens in memory and protects access using Swift Concurrency.
///
/// This actor serializes reads/writes to the access and refresh tokens to avoid data races
/// when multiple network requests run concurrently.
public actor AuthSession {
    private(set) var accessToken: String?
    private(set) var refreshToken: String?
    
    public init() {}
    
    public func setTokens(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    public func setAccessToken(_ token: String?) {
        self.accessToken = token
    }
    
    public func setRefreshToken(_ token: String?) {
        self.refreshToken = token
    }
    
    public func clearTokens() {
        accessToken = nil
        refreshToken = nil
    }
}
