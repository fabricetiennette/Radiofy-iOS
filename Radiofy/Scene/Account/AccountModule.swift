import SwiftUI

struct AccountModule {
    let authService: AuthServicing
    let onLogout: () -> Void

    @MainActor
    func makeView() -> some View {
        let viewModel = AccountViewModel(authService: authService)
        return AccountView(viewModel: viewModel, onLogout: onLogout)
    }
}
