import Foundation

public protocol AuthServicing {
    // Loads stored tokens (Keychain) into memory/session.
    func restoreSession() async
    func resumeSession() async throws
    
    // Auth
    func register(email: String, password: String) async throws
    func login(email: String, password: String) async throws
    func signInWithApple(idToken: String, givenName: String?, familyName: String?) async throws
    func refresh() async throws
    func logout() async
    
    // Email verification
    func verifyEmail(email: String, code: String) async throws
    func resendVerificationEmail(email: String) async throws
    
    // Password reset
    func requestPasswordReset(email: String) async throws
    func resetPassword(email: String, code: String, newPassword: String) async throws
    
    // User
    func me() async throws -> UserResponse
    func deleteAccount() async throws
}
