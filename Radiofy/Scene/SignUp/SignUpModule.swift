//
//  SignUpModule.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 17/05/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import UIKit
import Combine

typealias CallbackAuthResult = ((AuthResult) -> Void)
typealias CallbackResult = ((Result<Void, Error>) -> Void)

struct SignUpModule {

    typealias ViewModel = SignUpOutputBinding & SignUpInputBinding
    typealias Service = SignUpServiceProtocol
    typealias CoordinatorDelegate = SignUpViewModelDelegate

    private weak var coordinatorDelegate: CoordinatorDelegate?

    init(coordinatorDelegate: CoordinatorDelegate?) {
        self.coordinatorDelegate = coordinatorDelegate
    }

    var viewController: UIViewController {
        let service = SignUpService()
        let viewModel = SignUpViewModel(service: service)
        let signUpViewController = SignUpViewController.instantiate(from: .start)
        viewModel.delegate = coordinatorDelegate
        signUpViewController.viewModel = viewModel
        return signUpViewController
    }
}

protocol SignUpInputBinding {
    func signUpOneUser(_ nameTextField: String?, _ emailTextField: String?, _ passwordTextField: String?)
    func tapBack()
}

protocol SignUpOutputBinding {
    var errorSubject: PassthroughSubject<String, Never> { get set }
    var spinnerSubject: PassthroughSubject<Void, Never> { get set }
}

protocol SignUpServiceProtocol {
    var isAnonymous: Bool { get }
    func deleteCurrentUser()
    func saveImageDetails(with email: String)
    func createUser(name: String, password: String, email: String) -> AnyPublisher<UserProtocol, Error>
    func linkUserToAnonymous(email: String, password: String) -> AnyPublisher<UserProtocol, Error>
    func saveUserToDatabase(email: String, name: String) -> AnyPublisher<Void, Error>
    func sendEmailVerificationToUser() -> AnyPublisher<Any, Error>
}

protocol SignUpViewModelDelegate: AnyObject {
    func goToHomeView()
    func didTapOnBack()
}
