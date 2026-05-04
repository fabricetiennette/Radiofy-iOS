import AuthenticationServices

// Centralized helper used by both LogInView and SignUpView.
// Keeping it non-private makes it accessible across the module.
enum AppleSignInSupport {
    enum Mode {
        case signUp
        case signIn
    }

    struct Payload {
        let idToken: String
        let givenName: String?
        let familyName: String?
    }

    enum AppleSignInError: Error {
        case missingCredential
        case missingIdentityToken
    }

    static func configure(_ request: ASAuthorizationAppleIDRequest, mode: Mode) {
        switch mode {
        case .signUp:
            request.requestedScopes = [.fullName, .email]
        case .signIn:
            request.requestedScopes = []
        }
    }

    static func payload(from authorization: ASAuthorization) throws -> Payload {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            throw AppleSignInError.missingCredential
        }
        guard let tokenData = credential.identityToken,
              let idToken = String(data: tokenData, encoding: .utf8) else {
            throw AppleSignInError.missingIdentityToken
        }
        return Payload(
            idToken: idToken,
            givenName: credential.fullName?.givenName,
            familyName: credential.fullName?.familyName
        )
    }
}
