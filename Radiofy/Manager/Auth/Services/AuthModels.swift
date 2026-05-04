import Foundation

// MARK: - Requests

public struct AuthRegisterRequest: Codable {
    public let email: String
    public let password: String
}

public struct AuthLoginRequest: Codable {
    public let email: String
    public let password: String
}

public struct AuthRefreshRequest: Codable {
    public let refreshToken: String
}

public struct VerifyEmailRequest: Codable {
    public let email: String
    public let code: String
}

public struct ResendVerificationEmailRequest: Codable {
    public let email: String
}

public struct ForgotPasswordRequest: Codable {
    public let email: String
}

public struct ResetPasswordRequest: Codable {
    public let email: String
    public let code: String
    public let newPassword: String
}

public struct AppleSignInRequest: Codable {
    public let idToken: String
    public let givenName: String
    public let familyName: String
}

// MARK: - Responses

public struct RegisterResponse: Decodable, Equatable {
    public let message: String
    public let next: String?
}

public struct AuthTokenResponse: Codable {
    public let tokenType: String
    public let accessToken: String
    public let refreshToken: String
}

public struct UserResponse: Codable {
    public let email: String
    public let serverTime: String?
    public let displayName: String?

    public init(email: String, serverTime: String? = nil, displayName: String? = nil) {
        self.email = email
        self.serverTime = serverTime
        self.displayName = displayName
    }
}
