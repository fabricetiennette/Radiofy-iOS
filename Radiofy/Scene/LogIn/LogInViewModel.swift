//
//  LogInViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 28/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol LogInViewModelDelegate: class {
    func launchHomeScreen()
    func launchPasswordReset()
}

class LogInViewModel {

    private weak var delegate: LogInViewModelDelegate?

    var errorHandler: ((_ message: String) -> Void)?
    var spinnerHandler: (() -> Void)?

    private let authService: AuthService

    init(delegate: LogInViewModelDelegate?, authService: AuthService = .init()) {
        self.delegate = delegate
        self.authService = authService
    }

    // launch password reset
    func launchingPasswordReset() {
        delegate?.launchPasswordReset()
    }

    // Log in user
    func logInUser(with emailText: String?, _ passwordText: String?) {
        spinnerHandler?()
        if validateTextFields(emailText, passwordText) == nil {

            let email = emailText.clearedText()
            let password = passwordText.clearedText()

            logIn(with: email, password)
        }
    }

    // Sign In user from Firebase
    private func logIn(with email: String, _ password: String) {
        authService.signIn(email: email, password: password) { [weak self] result in
            guard let me = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    me.verifiedUserEmailandMakeHomeScreen()
                case .failure(let error):
                    me.errorHandler?(error.localizedDescription)
                }
            }
        }
    }

    // Verified user email if alright make home screen else send an error message
    private func verifiedUserEmailandMakeHomeScreen() {
        if authService.isUserEmailVerified() {
            makeHomeScreen()
        } else {
            signOutUser()
        }
    }

    // Sign Out user
    private func signOutUser() {
        authService.signOutUser { [weak self] result in
            guard let me = self else { return }
            switch result {
            case .success:
                me.errorHandler?(L1s.verifiedEmailFirst)
            case .failure:
                me.errorHandler?(L1s.verifiedEmailFirst)
            }
        }
    }

    // make home screen visible
    private func makeHomeScreen() {
        delegate?.launchHomeScreen()
    }

    // validate TextFieldstext are correct
    private func validateTextFields(
        _ emailTextField: String?,
        _ passwordTextField: String?
    ) -> Void? {

        // validate email is in a good format
        let email = emailTextField.clearedText()
        if email.isValidEmail() == false {
            return errorHandler?(L1s.emailInvalid)
        }

        // validate password is as expected
        let password = passwordTextField.clearedText()
        if password.isValidPassword() == false {
            return errorHandler?(L1s.passwordInvalid)
        }

        return nil
    }
}
