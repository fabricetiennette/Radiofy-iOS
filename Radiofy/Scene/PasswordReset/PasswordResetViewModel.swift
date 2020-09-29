//
//  PasswordResetViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 29/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation

class PasswordResetViewModel {

    private let authService: AuthService

    var errorHandler: ((_ message: String) -> Void)?
    var emailSuccessfullHandler: ((_ message: String) -> Void)?

    init(authService: AuthService = .init()) {
        self.authService = authService
    }

    func resetPassword(with emailText: String?) {
        if validateTextFields(emailText) == nil {

            let email = emailText.clearedText()

            sendPasswordReset(with: email)
        }
    }

    private func sendPasswordReset(with email: String) {
        authService.sendPasswordReset(email: email) { result in
            switch result {
            case .success:
                self.emailSuccessfullHandler?("\(L1s.sendTo) \(email).")
            case .failure(let error):
                self.errorHandler?(error.localizedDescription)
            }
        }
    }

    // validate emailTextFields text is correct
    private func validateTextFields(_ emailTextField: String?) -> Void? {

        // validate email is in a good format
        let email = emailTextField.clearedText()
        if email.isValidEmail() == false {
            return errorHandler?(L1s.emailInvalid)
        }

        return nil
    }
}
