import SwiftUI
import Combine

struct PasswordResetModule {

    let authService: AuthServicing

    @MainActor
    func makeView() -> some View {
        let viewModel = PasswordResetViewModel(authService: authService)
        return PasswordResetView(viewModel: viewModel)
    }
}

//protocol PasswordResetInputBinding {
//    func resetPassword(with emailText: String?)
//}
//
//protocol PasswordResetOutputBinding {
//    var errorSubject: PassthroughSubject<String, Never> { get set }
//    var emailSuccessSubject: PassthroughSubject<String, Never> { get set }
//}
//
//protocol PasswordResetServiceProtocol {
//    func sendPasswordReset(email: String) -> AnyPublisher<Void, Error>
//}
