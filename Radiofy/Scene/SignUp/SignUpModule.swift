//
//  SignUpModule.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 17/05/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import UIKit

typealias CallbackAuthResult = ((AuthResult) -> Void)
typealias CallbackResult = ((Result<Void, Error>) -> Void)

struct SignUpModule {

    typealias ViewModel = SignUpOutputBinding & SignUpInputBinding
    typealias Service = SignUpServiceProtocol
    typealias CoordinatorDelegate = SignUpViewModelDelegate

    // swiftlint:disable:next weak_delegate
    private let coordinatorDelegate: CoordinatorDelegate

    init(coordinatorDelegate: CoordinatorDelegate) {
        self.coordinatorDelegate = coordinatorDelegate
    }

    var viewController: UIViewController {
        let service = SignUpServices()
        let viewModel = SignUpViewModel(service: service)
        let signUpViewController = SignUpViewController.instantiate(from: .start)
        viewModel.delegate = coordinatorDelegate
        signUpViewController.viewModel = viewModel
        return signUpViewController
    }
}

protocol SignUpInputBinding {
    func signUpOneUser(_ nameTextField: String?, _ emailTextField: String?, _ passwordTextField: String?)
}

protocol SignUpOutputBinding {
    var errorHandler: ((_ message: String) -> Void) { get set }
    var spinnerHandler: (() -> Void) { get set }
    func tapBack()
}

protocol SignUpServiceProtocol {
    var isAnonymous: Bool { get }
    func deleteCurrentUser()
    func saveImageDetails(with email: String)
    func createUser(name: String, password: String, email: String, callback: @escaping CallbackAuthResult)
    func linkUserToAnonymous(email: String, password: String, callback: @escaping CallbackAuthResult)
    func saveUserToDatabase(email: String, name: String, callback: @escaping CallbackResult)
    func sendEmailVerificationToUser(callback: @escaping (Result<Any, Error>) -> Void)
}

protocol SignUpViewModelDelegate: AnyObject {
    func goToHomeView()
    func didTapOnBack()
}
