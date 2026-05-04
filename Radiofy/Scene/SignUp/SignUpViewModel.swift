import Foundation

@MainActor
final class SignUpViewModel: ObservableObject {

    // MARK: - Input
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false

    // MARK: - Output / UI state
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isPrivacyPolicyPresented: Bool = false

    // MARK: - Dependencies
    private let authService: AuthServicing
    private let onEmailVerificationRequired: (String) -> Void
    private let onAuthenticated: () -> Void

    init(
        authService: AuthServicing,
        onEmailVerificationRequired: @escaping (String) -> Void,
        onAuthenticated: @escaping () -> Void
    ) {
        self.authService = authService
        self.onEmailVerificationRequired = onEmailVerificationRequired
        self.onAuthenticated = onAuthenticated
    }

    // MARK: - Validation

    var passwordRequirementsText: String {
        "Your password needs at least 8 characters, 1 upper case, 1 lower case and 1 number."
    }

    var canSubmit: Bool {
        isValidEmail(email.trimmingCharacters(in: .whitespacesAndNewlines))
        && isValidPassword(password)
        && !isLoading
    }

    // MARK: - Actions

    func signUp() async {
        guard canSubmit else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
            try await authService.register(email: trimmedEmail, password: password)

            // The backend sends the verification code email and returns tokens only after verification.
            onEmailVerificationRequired(trimmedEmail)
        } catch {
            errorMessage = "Could not create account."
        }
    }

    func signInWithApple(idToken: String, givenName: String?, familyName: String?) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await authService.signInWithApple(idToken: idToken, givenName: givenName, familyName: familyName)
            onAuthenticated()
        } catch {
            errorMessage = "Apple sign in failed."
        }
    }
}

// MARK: - Private helpers

private extension SignUpViewModel {
    func isValidEmail(_ value: String) -> Bool {
        // Simple check for now; can be replaced by a stricter regex if needed.
        value.contains("@") && value.contains(".")
    }

    func isValidPassword(_ value: String) -> Bool {
        guard value.count >= 8 else { return false }
        let hasUpper = value.range(of: #"[A-Z]"#, options: .regularExpression) != nil
        let hasLower = value.range(of: #"[a-z]"#, options: .regularExpression) != nil
        let hasDigit = value.range(of: #"[0-9]"#, options: .regularExpression) != nil
        return hasUpper && hasLower && hasDigit
    }
}
