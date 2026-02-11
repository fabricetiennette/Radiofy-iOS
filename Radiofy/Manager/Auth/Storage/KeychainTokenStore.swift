import Foundation
import Security

public final class KeychainTokenStore: TokenStore {

    private let service = "com.radiofy.auth"
    private let account = "refreshToken"

    public init() {}

    public func readRefreshToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var out: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &out)

        if status == errSecItemNotFound { return nil }
        guard status == errSecSuccess, let data = out as? Data else { return nil }

        return String(data: data, encoding: .utf8)
    }

    public func writeRefreshToken(_ token: String) {
        let data = Data(token.utf8) 

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        // Replace existing value if present.
        SecItemDelete(query as CFDictionary)

        var attributes = query
        attributes[kSecValueData as String] = data
        _ = SecItemAdd(attributes as CFDictionary, nil)
    }

    public func deleteRefreshToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        SecItemDelete(query as CFDictionary)
    }
}
