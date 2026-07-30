import Foundation

@MainActor
final class PasswordResetViewModel: ObservableObject {

    enum Step: Equatable {
        case enterEmail
        case enterCodeAndPassword
        case done
    }

    @Published var step: Step = .enterEmail

    // MARK: - Input

    @Published var email: String = ""
    @Published var code: String = ""
    @Published var newPassword: String = ""

    // MARK: - Output / UI state

    @Published private(set) var state: LoadState = .idle
    @Published private(set) var successMessage: String?

    var isLoading: Bool { state.isLoading }
    var errorMessage: String? { state.errorMessage }

    // MARK: - Dependencies

    private let authService: AuthServicing

    init(authService: AuthServicing) {
        self.authService = authService
    }

    func setError(_ message: String) {
        state = .failed(message)
        successMessage = nil
    }

    // MARK: - Actions

    /// Requests an OTP code to be sent to the provided email.
    ///
    /// Security note: the API should always respond the same way (e.g. 204) whether the email exists or not.
    func requestPasswordReset() async {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        guard isValidEmail(trimmedEmail) else {
            setError(L10n.emailInvalid)
            return
        }

        state = .loading
        successMessage = nil

        do {
            try await authService.requestPasswordReset(email: trimmedEmail)

            // Do not reveal whether the email exists.
            state = .loaded
            successMessage = "If an account exists for \(trimmedEmail), you will receive an email with a verification code."
            step = .enterCodeAndPassword
        } catch {
            // Keep errors generic to avoid leaking account existence.
            setError("Could not request password reset. Please try again.")
        }
    }
    
    
    func requestNewPassword() async {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        guard isValidEmail(trimmedEmail) else {
            setError(L10n.emailInvalid)
            return
        }

        let trimmedCode = code.trimmingCharacters(in: .whitespacesAndNewlines)
        let isSixDigits = trimmedCode.count == 6 && trimmedCode.allSatisfy({ $0.isNumber })
        guard isSixDigits else {
            setError("Invalid verification code.")
            return
        }

        let trimmedPassword = newPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        guard isValidPassword(trimmedPassword) else {
            setError("Password must be at least 8 characters long and include 1 uppercase, 1 lowercase and 1 number.")
            return
        }

        state = .loading
        successMessage = nil

        do {
            try await authService.resetPassword(email: trimmedEmail, code: trimmedCode, newPassword: trimmedPassword)
            state = .loaded
            successMessage = "Password reset successful."
            step = .done
        } catch {
            setError("Could not reset password. Please try again.")
        }
    }
}

// MARK: - Private helpers

private extension PasswordResetViewModel {
    func isValidEmail(_ value: String) -> Bool {
        // Keep this simple; you can swap for a stricter validator later.
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
