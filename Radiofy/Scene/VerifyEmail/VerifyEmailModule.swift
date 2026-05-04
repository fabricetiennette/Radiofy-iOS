import SwiftUI

struct VerifyEmailModule {
    let authService: AuthServicing
    let onAuthenticated: () -> Void
    let email: String

    @MainActor
    func makeView() -> some View {
        let viewModel = VerifyEmailViewModel(authService: authService,
                                             onAuthenticated: onAuthenticated,
                                             email: email)
        return VerifyEmailView(viewModel: viewModel)
    }
}
