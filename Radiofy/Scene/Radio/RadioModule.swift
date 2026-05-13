import SwiftUI

/// Builds the Sign Up feature (SwiftUI) with its dependencies.
/// Keeps composition outside the view for a clean architecture.
struct RadioModule {
    let authService: AuthServicing


    @MainActor
    func makeView() -> some View {
        let viewModel = RadioViewModel(authService: authService)
        return RadioView(viewModel: viewModel)
    }
}

