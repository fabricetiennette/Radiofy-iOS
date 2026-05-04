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

    @Published private(set) var isLoading: Bool = false
    @Published private(set) var successMessage: String?
    @Published private(set) var errorMessage: String?

    // MARK: - Dependencies

    private let authService: AuthServicing

    init(authService: AuthServicing) {
        self.authService = authService
    }
    
    func setError(_ message: String) {
        errorMessage = message
        successMessage = nil
    }

    // MARK: - Actions

    /// Requests an OTP code to be sent to the provided email.
    ///
    /// Security note: the API should always respond the same way (e.g. 204) whether the email exists or not.
    func requestPasswordReset() async {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        guard isValidEmail(trimmedEmail) else {
            errorMessage = L10n.emailInvalid
            successMessage = nil
            return
        }

        isLoading = true
        errorMessage = nil
        successMessage = nil
        defer { isLoading = false }

        do {
            try await authService.requestPasswordReset(email: trimmedEmail)

            // Do not reveal whether the email exists.
            successMessage = "If an account exists for \(trimmedEmail), you will receive an email with a verification code."
            step = .enterCodeAndPassword
        } catch {
            // Keep errors generic to avoid leaking account existence.
            errorMessage = "Could not request password reset. Please try again."
        }
    }
    
    
    func requestNewPassword() async {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        guard isValidEmail(trimmedEmail) else {
            errorMessage = L10n.emailInvalid
            successMessage = nil
            return
        }

        let trimmedCode = code.trimmingCharacters(in: .whitespacesAndNewlines)
        let isSixDigits = trimmedCode.count == 6 && trimmedCode.allSatisfy({ $0.isNumber })
        guard isSixDigits else {
            errorMessage = "Invalid verification code."
            successMessage = nil
            return
        }

        let trimmedPassword = newPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        guard isValidPassword(trimmedPassword) else {
            errorMessage = "Password must be at least 8 characters long and include 1 uppercase, 1 lowercase and 1 number."
            successMessage = nil
            return
        }

        isLoading = true
        errorMessage = nil
        successMessage = nil
        defer { isLoading = false }

        do {
            try await authService.resetPassword(email: trimmedEmail, code: trimmedCode, newPassword: trimmedPassword)
            successMessage = "Password reset successful."
            step = .done
        } catch {
            errorMessage = "Could not reset password. Please try again."
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
