//
//  LogInViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 28/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

//import Foundation
//import Combine
//
//class LogInViewModel: LogInModule.ViewModel {
//
//    weak var delegate: LogInModule.CoordinatorDelegate?
//
//    var errorSubject = PassthroughSubject<String, Never>()
//    var spinnerSubject = PassthroughSubject<Void, Never>()
//
//    private var disposeBag = Set<AnyCancellable>()
//    private let service: LogInModule.Service
//
//    init(service: LogInModule.Service) {
//        self.service = service
//    }
//
//    // launch password reset
//    func didTapPasswordReset() {
//        delegate?.launchPasswordReset()
//    }
//
//    // Log in user
//    func logInUser(with emailText: String?, _ passwordText: String?) {
//        spinnerSubject.send()
//        if validateTextFields(emailText, passwordText) == nil {
//
//            let email = emailText.clearedText()
//            let password = passwordText.clearedText()
//
//            logIn(with: email, password)
//        }
//    }
//
//    func tapBack() {
//        delegate?.didTapOnBack()
//    }
//
//    // Sign In user from Firebase
//    private func logIn(with email: String, _ password: String) {
//        service
//            .signIn(email: email, password: password)
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] result in
//                guard let self = self else { return }
//                switch result {
//                case .failure(let error):
//                    self.errorSubject.send(error.localizedDescription)
//                case .finished: break
//                }
//            } receiveValue: { [weak self] _ in
//                guard let self = self else { return }
//                self.verifiedUserEmail()
//            }
//            .store(in: &disposeBag)
//    }
//
//    // Verified user email if alright make home screen else send an error message
//    private func verifiedUserEmail() {
//        if service.isUserEmailVerified {
//            showHomeScreen()
//        } else {
//            signOutUser()
//        }
//    }
//
//    // Sign Out user
//    private func signOutUser() {
//        service
//            .signOutUser()
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { [weak self] result in
//                guard let self = self else { return }
//                switch result {
//                case .failure:
//                    self.errorSubject.send(L10n.verifiedEmailFirst)
//                case .finished: break
//                }
//            }, receiveValue: { [weak self] _ in
//                guard let self = self else { return }
//                self.errorSubject.send(L10n.verifiedEmailFirst)
//            })
//            .store(in: &disposeBag)
//    }
//
//    // make home screen visible
//    private func showHomeScreen() {
//        delegate?.goToHomeView()
//    }
//
//    // validate TextFieldstext are correct
//    private func validateTextFields(
//        _ emailTextField: String?,
//        _ passwordTextField: String?
//    ) -> Void? {
//
//        // validate email is in a good format
//        let email = emailTextField.clearedText()
//        if email.isValidEmail() == false {
//            return errorSubject.send(L10n.emailInvalid)
//        }
//
//        // validate password is as expected
//        let password = passwordTextField.clearedText()
//        if password.isValidPassword() == false {
//            return errorSubject.send(L10n.passwordInvalid)
//        }
//
//        return nil
//    }
//}
//
//
//  LogInViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 28/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation

@MainActor
final class LogInViewModel: ObservableObject {

    // MARK: - Input

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false

    // MARK: - Output / UI state

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Dependencies

    private let authService: AuthServicing
    private let onAuthenticated: () -> Void
    private let onBack: () -> Void
    private let onForgotPassword: () -> Void

    init(
        authService: AuthServicing,
        onAuthenticated: @escaping () -> Void,
        onBack: @escaping () -> Void = {},
        onForgotPassword: @escaping () -> Void = {}
    ) {
        self.authService = authService
        self.onAuthenticated = onAuthenticated
        self.onBack = onBack
        self.onForgotPassword = onForgotPassword
    }

    // MARK: - Validation

    var canSubmit: Bool {
        isValidEmail(email) && !password.isEmpty && !isLoading
    }

    // MARK: - Actions

    func didTapPasswordReset() {
        onForgotPassword()
    }

    func tapBack() {
        onBack()
    }

    func logIn() async {
        guard canSubmit else {
            errorMessage = "Please enter a valid email and password."
            return
        }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            _ = try await authService.login(email: email, password: password)
            onAuthenticated()
        } catch {
            errorMessage = "Invalid email or password."
        }
    }
    
    func signInWithApple(idToken: String, givenName: String?, familyName: String?) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            _ = try await authService.signInWithApple(idToken: idToken, givenName: givenName, familyName: familyName)
            onAuthenticated()
        } catch {
            errorMessage = "Apple sign in failed."
        }
    }
}

// MARK: - Private helpers

private extension LogInViewModel {
    func isValidEmail(_ value: String) -> Bool {
        // Simple check for now; can be replaced by a stricter validation later.
        value.contains("@") && value.contains(".")
    }
}
