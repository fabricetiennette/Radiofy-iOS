import SwiftUI
import Combine

struct PasswordResetModule {

    let authService: AuthServicing
    let onGoToLogin: () -> Void

    @MainActor
    func makeView() -> some View {
        let viewModel = PasswordResetViewModel(authService: authService)
        return PasswordResetView(viewModel: viewModel, onGoToLogin: onGoToLogin)
    }
}
