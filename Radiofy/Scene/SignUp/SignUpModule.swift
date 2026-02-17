import SwiftUI

/// Builds the Sign Up feature (SwiftUI) with its dependencies.
/// Keeps composition outside the view for a clean architecture.
struct SignUpModule {
    let authService: AuthServicing
    let onEmailVerificationRequired: (String) -> Void
    let onAuthenticated: () -> Void

    @MainActor
    func makeView() -> some View {
        let viewModel = SignUpViewModel(authService: authService,
                                        onEmailVerificationRequired: onEmailVerificationRequired,
                                        onAuthenticated: onAuthenticated)
        return SignUpView(viewModel: viewModel)
    }
}
