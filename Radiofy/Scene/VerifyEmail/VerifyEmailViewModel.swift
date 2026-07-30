import Foundation

@MainActor
final class VerifyEmailViewModel: ObservableObject {
    
    // MARK: - Input

    @Published var email: String = ""
    @Published var code: String = ""

    @Published private(set) var cooldownSeconds: Int = 0

    // MARK: - Output / UI state

    @Published private(set) var state: LoadState = .idle
    @Published private(set) var successMessage: String?

    var isLoading: Bool { state.isLoading }
    var errorMessage: String? { state.errorMessage }

    var canResend: Bool { !isLoading && cooldownSeconds == 0 }

    // MARK: - Dependencies

    private let authService: AuthServicing
    private let onAuthenticated: () -> Void
    
    init(authService: AuthServicing, onAuthenticated: @escaping () -> Void, email: String? = nil) {
        self.authService = authService
        self.onAuthenticated = onAuthenticated
        self.email = email ?? ""
    }
    
    func verifyEmail() async {
        print("➡️ verifyEmail tapped")
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

        state = .loading
        successMessage = nil

        do {
            try await authService.verifyEmail(email: trimmedEmail, code: trimmedCode)

            state = .loaded
            successMessage = "Email verified successfully."
            print("✅ verifyEmail success — calling onAuthenticated()")
            onAuthenticated()
        } catch {
            print("❌ verifyEmail failed:", error)
            setError("Failed to verify email.")
        }
    }

    func resendVerificationCode() async {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard isValidEmail(trimmedEmail) else {
            setError(L10n.emailInvalid)
            return
        }

        state = .loading
        successMessage = nil

        do {
            try await authService.resendVerificationEmail(email: trimmedEmail)
            state = .loaded
            successMessage = "Verification code sent."
            startCooldown(seconds: 60)
        } catch {
            setError("Failed to resend verification code.")
        }
    }

    private func setError(_ message: String) {
        state = .failed(message)
        successMessage = nil
    }

    private func startCooldown(seconds: Int) {
        cooldownSeconds = seconds
        Task { @MainActor [weak self] in
            guard let self else { return }
            while self.cooldownSeconds > 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                self.cooldownSeconds -= 1
            }
        }
    }
    
}

// MARK: - Private helpers

private extension VerifyEmailViewModel {
    func isValidEmail(_ value: String) -> Bool {
        // Keep this simple; you can swap for a stricter validator later.
        value.contains("@") && value.contains(".")
    }
}
