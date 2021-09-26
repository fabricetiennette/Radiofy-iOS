//
//  SignUpViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 27/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
import Combine

class SignUpViewModel: SignUpModule.ViewModel {

    weak var delegate: SignUpModule.CoordinatorDelegate?

    var errorSubject = PassthroughSubject<String, Never>()
    var spinnerSubject = PassthroughSubject<Void, Never>()

    private var disposeBag = Set<AnyCancellable>()
    private let service: SignUpModule.Service

    init(service: SignUpModule.Service) {
        self.service = service
    }

    // Sign up user
    func signUpOneUser(_ nameTextField: String?,
                       _ emailTextField: String?,
                       _ passwordTextField: String?) {
        spinnerSubject.send()
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
        service
            .createUser(name: name, password: password, email: email)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.errorSubject.send(error.localizedDescription)
                case .finished: break
                }
            } receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.service.saveImageDetails(with: email)
                self.saveUserToDatabase(email: email, name: name)
                self.sendEmailVerificationToUser()
                self.showHomeScreen()
            }
            .store(in: &disposeBag)
    }

    func linkAnonymousToUser(_ name: String, _ password: String, _ email: String) {
        service
            .linkUserToAnonymous(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.errorSubject.send(error.localizedDescription)
                case .finished: break
                }
            } receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.service.saveImageDetails(with: email)
                self.saveUserToDatabase(email: email, name: name)
                self.sendEmailVerificationToUser()
                self.showHomeScreen()
            }
            .store(in: &disposeBag)
    }

    // save user to database
    func saveUserToDatabase(email: String, name: String) {
        service
            .saveUserToDatabase(email: email, name: name)
            .sink(receiveCompletion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure:
                    self.errorSubject.send(L10n.errorSavingUserData)
                case .finished: break
                }
            }, receiveValue: { _ in })
            .store(in: &disposeBag)
    }

    // send a verification email to the user
    func sendEmailVerificationToUser() {
        service
            .sendEmailVerificationToUser()
            .sink(receiveCompletion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.errorSubject.send(error.localizedDescription)
                case .finished: break
                }
            }, receiveValue: { _ in })
            .store(in: &disposeBag)
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
            return errorSubject.send(L10n.nameInvalid)
        }

        // validate email is in a good format
        let email = emailTextField.clearedText()
        if email.isValidEmail() == false {
            return errorSubject.send(L10n.emailInvalid)
        }

        // validate password is as expected
        let password = passwordTextField.clearedText()
        if password.isValidPassword() == false {
            return errorSubject.send(L10n.passwordInvalid)
        }

        return nil
    }
}
