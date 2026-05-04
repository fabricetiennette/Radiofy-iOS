import Foundation

public final class AuthService: AuthServicing {

    private let baseURL: URL
    private let urlSession: URLSession
    private let tokenStore: TokenStore
    private let authSession: AuthSession

    public init(
        baseURL: URL,
        urlSession: URLSession = .shared,
        tokenStore: TokenStore = KeychainTokenStore(),
        authSession: AuthSession = AuthSession()
    ) {
        self.baseURL = baseURL
        self.urlSession = urlSession
        self.tokenStore = tokenStore
        self.authSession = authSession
    }

    // MARK: - Session

    public func restoreSession() async {
        // Keychain access can be slow; avoid doing it on the MainActor.
        let refreshToken = await Task.detached(priority: .userInitiated) { [tokenStore] in
            tokenStore.readRefreshToken()
        }.value
        await authSession.setRefreshToken(refreshToken)
    }

    /// Restores the refresh token from storage and attempts to refresh the access token.
    /// Use this on app launch before calling authenticated endpoints.
    public func resumeSession() async throws {
        await restoreSession()
        // If there is no refresh token, the user is not authenticated.
        guard await authSession.refreshToken != nil else {
            throw AuthServiceError.notAuthenticated
        }
        try await refresh()
    }

    // MARK: - Auth

    /// Signs in (or creates an account) using Sign in with Apple.
    /// returns access + refresh tokens.
    public func signInWithApple(idToken: String, givenName: String?, familyName: String?) async throws {
        let body = AppleSignInRequest(idToken: idToken,
                                      givenName: givenName ?? "",
                                      familyName: familyName ?? "")
        
        let (data, _) = try await sendRaw(
            endpoint: .appleSignIn,
            body: body,
            authenticated: false
        )
        
        guard !data.isEmpty else {
            throw AuthServiceError.emptyData
        }
        
        let tokens = try JSONDecoder().decode(AuthTokenResponse.self, from: data)
        await saveTokens(tokens)
    }

    public func register(email: String, password: String) async throws {
        let body = AuthRegisterRequest(email: email, password: password)
        _ = try await sendRaw(
            endpoint: .register,
            body: body,
            authenticated: false
        )
        // Tokens are issued only after email verification.
    }

    public func login(email: String, password: String) async throws {
        let body = AuthLoginRequest(email: email, password: password)
        let (data, _) = try await sendRaw(
            endpoint: .login,
            body: body,
            authenticated: false
        )

        guard !data.isEmpty else {
            throw AuthServiceError.emptyData
        }

        let tokens = try JSONDecoder().decode(AuthTokenResponse.self, from: data)
        await saveTokens(tokens)
    }

    public func refresh() async throws {
        guard let refreshToken = await authSession.refreshToken else {
            throw AuthServiceError.notAuthenticated
        }
        let body = AuthRefreshRequest(refreshToken: refreshToken)
        let requestBody = try JSONEncoder().encode(body)
        let (data, _) = try await sendRequest(
            endpoint: .refresh,
            body: requestBody,
            authenticated: false
        )
        let tokens = try JSONDecoder().decode(AuthTokenResponse.self, from: data)
        // Update access token.
        await authSession.setAccessToken(tokens.accessToken)
        // Handle refresh token rotation if it changes.
        if tokens.refreshToken != refreshToken {
            await authSession.setRefreshToken(tokens.refreshToken)
            // Keychain access can be slow; avoid doing it on the MainActor.
            _ = await Task.detached(priority: .userInitiated) { [tokenStore] in
                tokenStore.writeRefreshToken(tokens.refreshToken)
            }.value
        }
    }

    public func logout() async {
        // Keychain access can be slow; avoid doing it on the MainActor.
        _ = await Task.detached(priority: .userInitiated) { [tokenStore] in
            tokenStore.deleteRefreshToken()
        }.value
        await authSession.clearTokens()
    }

    // MARK: - Email verification

    public func verifyEmail(email: String, code: String) async throws {
        let body = VerifyEmailRequest(email: email, code: code)

        let (data, _) = try await sendRaw(
            endpoint: .verifyEmail,
            body: body,
            authenticated: false
        )

        // Some backends return tokens after verification; others return an empty body.
        guard !data.isEmpty else {
            return
        }

        let tokens = try JSONDecoder().decode(AuthTokenResponse.self, from: data)
        await saveTokens(tokens)
    }

    public func resendVerificationEmail(email: String) async throws {
        let body = ResendVerificationEmailRequest(email: email)
        _ = try await sendRaw(
            endpoint: .resendVerification,
            body: body,
            authenticated: false
        )
    }

    // MARK: - Password reset

    public func requestPasswordReset(email: String) async throws {
        let body = ForgotPasswordRequest(email: email)
        _ = try await sendRaw(
            endpoint: .forgotPassword,
            body: body,
            authenticated: false
        )
    }

    public func resetPassword(email: String, code: String, newPassword: String) async throws {
        let body = ResetPasswordRequest(email: email, code: code, newPassword: newPassword)
        _ = try await sendRaw(
            endpoint: .resetPassword,
            body: body,
            authenticated: false
        )
    }

    // MARK: - User

    private func sendJSON<T: Decodable>(
        endpoint: AuthEndpoint,
        authenticated: Bool
    ) async throws -> T {
        try await sendJSON(endpoint: endpoint, body: nil as Data?, authenticated: authenticated)
    }

    public func me() async throws -> UserResponse {
        try await sendJSON(endpoint: .me, authenticated: true)
    }

    public func deleteAccount() async throws {
        _ = try await sendRequest(
            endpoint: .deleteMe,
            body: nil,
            authenticated: true
        )
        await logout()
    }

    // MARK: - Internals

    private func saveTokens(_ tokens: AuthTokenResponse) async {
        await authSession.setTokens(accessToken: tokens.accessToken, refreshToken: tokens.refreshToken)
        // Keychain access can be slow; avoid doing it on the MainActor.
        _ = await Task.detached(priority: .userInitiated) { [tokenStore] in
            tokenStore.writeRefreshToken(tokens.refreshToken)
        }.value
    }

    private func sendJSON<T: Decodable, Body: Encodable>(
        endpoint: AuthEndpoint,
        body: Body,
        authenticated: Bool
    ) async throws -> T {
        let data: Data
        if let raw = body as? Data {
            data = raw
        } else {
            data = try JSONEncoder().encode(body)
        }
        return try await sendJSON(endpoint: endpoint, body: data, authenticated: authenticated)
    }

    private func sendJSON<T: Decodable>(
        endpoint: AuthEndpoint,
        body: Data?,
        authenticated: Bool
    ) async throws -> T {
        let (data, _) = try await sendRequest(endpoint: endpoint, body: body, authenticated: authenticated)
        return try JSONDecoder().decode(T.self, from: data)
    }

    @discardableResult
    private func sendRaw<Body: Encodable>(
        endpoint: AuthEndpoint,
        body: Body,
        authenticated: Bool
    ) async throws -> (Data, HTTPURLResponse) {
        let data = try JSONEncoder().encode(body)
        return try await sendRequest(endpoint: endpoint, body: data, authenticated: authenticated)
    }

    @discardableResult
    private func sendRequest(
        endpoint: AuthEndpoint,
        body: Data?,
        authenticated: Bool
    ) async throws -> (Data, HTTPURLResponse) {

        var request = URLRequest(url: baseURL.appendingPathComponent(endpoint.path))
        // Prevent infinite loading if the server is unreachable or stalls.
        request.timeoutInterval = 20

        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if let body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }

        if authenticated {
            guard let accessToken = await authSession.accessToken else {
                throw AuthServiceError.notAuthenticated
            }
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await urlSession.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw AuthServiceError.invalidResponse
        }

        guard (200..<300).contains(http.statusCode) else {
            let message = String(data: data, encoding: .utf8)
            throw AuthServiceError.server(status: http.statusCode, message: message)
        }

        return (data, http)
    }
}

public enum AuthServiceError: Error, Equatable {
    case notImplemented
    case notAuthenticated
    case invalidResponse
    case emptyData
    case server(status: Int, message: String?)
}
