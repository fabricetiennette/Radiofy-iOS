import SwiftUI

@MainActor
final class RadioViewModel: ObservableObject {
    // MARK: - Dependencies
    private let authService: AuthServicing
    
    init(authService: AuthServicing) {
        self.authService = authService
    }
}
