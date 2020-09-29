//
//  SignUpViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 27/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol SignUpViewModelDelegate: class {
    func callhomeScreen()
}

class SignUpViewModel {

    // MARK: - Delegate

    private weak var delegate: SignUpViewModelDelegate?

    // MARK: - Closure

    var errorHandler: ((_ message: String) -> Void)?
    var spinnerHandler: (() -> Void)?

    // MARK: - Injection

    private let authService: AuthService
    private let firestoreService: FirestoreService
    private let storageService: StorageService

    // MARK: - init

    init(
        delegate: SignUpViewModelDelegate?,
        authService: AuthService = .init(),
        firestoreService: FirestoreService = .init(),
        storageService: StorageService = .init()
    ) {
        self.delegate = delegate
        self.authService = authService
        self.firestoreService = firestoreService
        self.storageService = storageService
    }

    // MARK: - ViewModel Method

    // Sign up user
    func signUpOneUser(
        _ nameTextField: String?,
        _ emailTextField: String?,
        _ passwordTextField: String?
    ) {
        spinnerHandler?()
        if validateTextFields(nameTextField, emailTextField, passwordTextField) == nil {

            let name = nameTextField.clearedText()
            let password = passwordTextField.clearedText()
            let email = emailTextField.clearedText()

            if authService.isAnonymous {
                linkAnonymousToUser(name, password, email)
            } else {
                createUser(with: name, password, email)
            }
        }
    }

    // MARK: - Private

    // create and save user in firebase
    private func createUser(with name: String, _ password: String, _ email: String) {
        authService.createUser(name: name, password: password, email: email) { result in
            switch result {
            case .success:
                self.storageService.saveImageDetails(with: email)
                self.saveUserToDatabase(email: email, name: name)
                self.sendEmailVerificationToUser()
                self.showHomeScreen()
            case .failure(let error):
                self.errorHandler?(error.localizedDescription)
            }
        }
    }

    private func linkAnonymousToUser(
        _ name: String,
        _ password: String,
        _ email: String) {
        authService.linkUserToAnonymous(email: email, password: password) { result in
            switch result {
            case .success:
                self.storageService.saveImageDetails(with: email)
                self.saveUserToDatabase(email: email, name: name)
                self.sendEmailVerificationToUser()
                self.showHomeScreen()
            case .failure(let error):
                self.errorHandler?(error.localizedDescription)
            }
        }
    }

    // save user to database
    private func saveUserToDatabase(email: String, name: String) {
        firestoreService.saveUserToDatabase(
        email: email, name: name) { result in
            switch result {
            case .success: break
            case .failure:
                self.errorHandler?(L1s.dataSavingError)
            }
        }
    }

    // send a verification email to the user
    private func sendEmailVerificationToUser() {
        authService.sendEmailVerificationToUser { result in
            switch result {
            case .success: break
            case .failure(let error):
                self.errorHandler?(error.localizedDescription)
            }
        }
    }

    private func ifAnonymousDeleteUser() {
        guard let user = Auth.auth().currentUser else { return}
        if authService.isAnonymous {
            user.delete()
        }
    }

    // launch HomeViewController
    private func showHomeScreen() {
        delegate?.callhomeScreen()
    }

    // validate TextFieldstext are correct
    private func validateTextFields(
        _ nameTextField: String?,
        _ emailTextField: String?,
        _ passwordTextField: String?
    ) -> Void? {

        // validate name is as expected
        let name = nameTextField.clearedText()
        if name.isNameValid() == false {
            return errorHandler?(L1s.nameInvalid)
        }

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
