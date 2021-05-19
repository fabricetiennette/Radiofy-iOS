//
//  SignUpViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 27/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
import FirebaseAuth

class SignUpViewModel: SignUpModule.ViewModel {

    weak var delegate: SignUpModule.CoordinatorDelegate?

    var errorHandler: ((_ message: String) -> Void) = { _ in }
    var spinnerHandler: (() -> Void) = {}

    private let service: SignUpModule.Service

    init(service: SignUpModule.Service) {
        self.service = service
    }

    // Sign up user
    func signUpOneUser(_ nameTextField: String?,
                       _ emailTextField: String?,
                       _ passwordTextField: String?) {
        spinnerHandler()
        if validateTextFields(nameTextField, emailTextField, passwordTextField) == nil {

            let name = nameTextField.clearedText()
            let password = passwordTextField.clearedText()
            let email = emailTextField.clearedText()

            if service.isAnonymous {
                linkAnonymousToUser(name, password, email)
            } else {
                createUser(with: name, password, email)
            }
        }
    }

    func tapBack() {
        delegate?.didTapOnBack()
    }
}

private extension SignUpViewModel {

    // create and save user in firebase
    func createUser(with name: String, _ password: String, _ email: String) {
        service.createUser(name: name, password: password, email: email) { result in
            switch result {
            case .success:
                self.service.saveImageDetails(with: email)
                self.saveUserToDatabase(email: email, name: name)
                self.sendEmailVerificationToUser()
                self.showHomeScreen()
            case .failure(let error):
                self.errorHandler(error.localizedDescription)
            }
        }
    }

    func linkAnonymousToUser(_ name: String, _ password: String, _ email: String) {
        service.linkUserToAnonymous(email: email, password: password) { result in
            switch result {
            case .success:
                self.service.saveImageDetails(with: email)
                self.saveUserToDatabase(email: email, name: name)
                self.sendEmailVerificationToUser()
                self.showHomeScreen()
            case .failure(let error):
                self.errorHandler(error.localizedDescription)
            }
        }
    }

    // save user to database
    func saveUserToDatabase(email: String, name: String) {
        service.saveUserToDatabase(
        email: email, name: name) { result in
            switch result {
            case .success: break
            case .failure:
                self.errorHandler(L1s.dataSavingError)
            }
        }
    }

    // send a verification email to the user
    func sendEmailVerificationToUser() {
        service.sendEmailVerificationToUser { result in
            switch result {
            case .success: break
            case .failure(let error):
                self.errorHandler(error.localizedDescription)
            }
        }
    }

    func ifAnonymousDeleteUser() {
        service.deleteCurrentUser()
    }

    // launch HomeViewController
    func showHomeScreen() {
        delegate?.goToHomeView()
    }

    // validate TextFieldstext are correct
    func validateTextFields(_ nameTextField: String?,
                            _ emailTextField: String?,
                            _ passwordTextField: String?) -> Void? {

        // validate name is as expected
        let name = nameTextField.clearedText()
        if name.isNameValid() == false {
            return errorHandler(L1s.nameInvalid)
        }

        // validate email is in a good format
        let email = emailTextField.clearedText()
        if email.isValidEmail() == false {
            return errorHandler(L1s.emailInvalid)
        }

        // validate password is as expected
        let password = passwordTextField.clearedText()
        if password.isValidPassword() == false {
            return errorHandler(L1s.passwordInvalid)
        }

        return nil
    }
}
