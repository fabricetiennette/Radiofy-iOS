import AuthenticationServices

enum AppleSignInHelper {
    static func configure(_ request: ASAuthorizationAppleIDRequest, for mode: Mode) {
        switch mode {
        case .signUp:
            // Only useful the first time; Apple returns these only once.
            request.requestedScopes = [.fullName, .email]
        case .signIn:
            // Usually enough for sign-in; you can still request scopes, but it’s not necessary.
            request.requestedScopes = []
        }
    }

    static func extract(from authorization: ASAuthorization) throws -> (idToken: String, givenName: String?, familyName: String?) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            throw AppleSignInError.missingCredential
        }
        guard let tokenData = credential.identityToken,
              let idToken = String(data: tokenData, encoding: .utf8) else {
            throw AppleSignInError.missingIdentityToken
        }
        return (idToken, credential.fullName?.givenName, credential.fullName?.familyName)
    }

    enum Mode { case signUp, signIn }

    enum AppleSignInError: Error {
        case missingCredential
        case missingIdentityToken
    }
}
