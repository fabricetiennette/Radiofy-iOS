import Foundation

public final class AuthService: AuthServicing {

    private let baseURL: URL
    private let urlSession: URLSession
    private let tokenStore: TokenStore
    private let authSession: AuthSession

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

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
        let refreshToken = tokenStore.readRefreshToken()
        await authSession.setRefreshToken(refreshToken)
    }

    // MARK: - Auth

    /// Signs in (or creates an account) using Sign in with Apple.
    ///
    /// TODO: Implement backend endpoint (e.g. POST /auth/apple) that validates the Apple identity token
    /// and returns access + refresh tokens.
    public func signInWithApple(idToken: String, givenName: String?, familyName: String?) async throws {
        throw AuthServiceError.notImplemented
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
        let tokens: AuthTokenResponse = try await sendJSON(
            endpoint: .login,
            body: body,
            authenticated: false
        )
        await saveTokens(tokens)
    }

    public func refresh() async throws {
        guard let refreshToken = await authSession.refreshToken else {
            throw AuthServiceError.notAuthenticated
        }

        let body = AuthRefreshRequest(refreshToken: refreshToken)
        let tokens: AuthTokenResponse = try await sendJSON(
            endpoint: .refresh,
            body: body,
            authenticated: false
        )

        // Update access token.
        await authSession.setAccessToken(tokens.accessToken)

        // Handle refresh token rotation if it changes.
        if tokens.refreshToken != refreshToken {
            await authSession.setRefreshToken(tokens.refreshToken)
            tokenStore.writeRefreshToken(tokens.refreshToken)
        }
    }

    public func logout() async {
        tokenStore.deleteRefreshToken()
        await authSession.clearTokens()
    }

    // MARK: - Email verification

    public func verifyEmail(email: String, code: String) async throws {
        let body = VerifyEmailRequest(email: email, code: code)
        let tokens: AuthTokenResponse = try await sendJSON(
            endpoint: .verifyEmail,
            body: body,
            authenticated: false
        )
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

    public func me() async throws -> UserResponse {
        try await sendJSON(
            endpoint: .me,
            body: Optional<Data>.none,
            authenticated: true
        )
    }

    public func deleteAccount() async throws {
        _ = try await sendRequest(
            endpoint: .deleteMe,
            body: Optional<Data>.none,
            authenticated: true
        )
        await logout()
    }

    // MARK: - Internals

    private func saveTokens(_ tokens: AuthTokenResponse) async {
        await authSession.setTokens(accessToken: tokens.accessToken, refreshToken: tokens.refreshToken)
        tokenStore.writeRefreshToken(tokens.refreshToken)
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
            data = try encoder.encode(body)
        }
        return try await sendJSON(endpoint: endpoint, body: data, authenticated: authenticated)
    }

    private func sendJSON<T: Decodable>(
        endpoint: AuthEndpoint,
        body: Data?,
        authenticated: Bool
    ) async throws -> T {
        let (data, _) = try await sendRequest(endpoint: endpoint, body: body, authenticated: authenticated)
        return try decoder.decode(T.self, from: data)
    }

    @discardableResult
    private func sendRaw<Body: Encodable>(
        endpoint: AuthEndpoint,
        body: Body,
        authenticated: Bool
    ) async throws -> (Data, HTTPURLResponse) {
        let data = try encoder.encode(body)
        return try await sendRequest(endpoint: endpoint, body: data, authenticated: authenticated)
    }

    @discardableResult
    private func sendRequest(
        endpoint: AuthEndpoint,
        body: Data?,
        authenticated: Bool
    ) async throws -> (Data, HTTPURLResponse) {

        var request = URLRequest(url: baseURL.appendingPathComponent(endpoint.path))
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
    case server(status: Int, message: String?)
}
