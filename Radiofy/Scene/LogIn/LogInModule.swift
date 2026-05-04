//
//  LoginModule.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 25/05/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

//import Foundation
//import UIKit
//import Combine
//
//struct LogInModule {
//
//    typealias ViewModel = LogInOutputBinding & LogInInputBinding
//    typealias Service = LogInServiceProtocol
//    typealias CoordinatorDelegate = LogInViewModelDelegate
//
//    private weak var coordinatorDelegate: CoordinatorDelegate?
//
//    init(coordinatorDelegate: CoordinatorDelegate?) {
//        self.coordinatorDelegate = coordinatorDelegate
//    }
//
//    var viewController: UIViewController {
//        let service = LogInService()
//        let viewModel = LogInViewModel(service: service)
//        let loginViewController = LogInViewController.instantiate(from: .start)
//        viewModel.delegate = coordinatorDelegate
//        loginViewController.viewModel = viewModel
//        return loginViewController
//    }
//}
//
//protocol LogInOutputBinding {
//    var errorSubject: PassthroughSubject<String, Never> { get set }
//    var spinnerSubject: PassthroughSubject<Void, Never> { get set }
//}
//
//protocol LogInInputBinding {
//    func logInUser(with emailText: String?, _ passwordText: String?)
//    func didTapPasswordReset()
//    func tapBack()
//}
//
//protocol LogInServiceProtocol {
//    var isUserEmailVerified: Bool { get }
//    func signOutUser() -> AnyPublisher<Any, Error>
//    func signIn(email: String, password: String) -> AnyPublisher<UserProtocol, Error>
//}
//
//protocol LogInViewModelDelegate: AnyObject {
//    func goToHomeView()
//    func didTapOnBack()
//    func launchPasswordReset()
//}

//
//  LogInModule.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 25/05/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import SwiftUI

/// Builds the Log In feature (SwiftUI) with its dependencies.
struct LogInModule {
    let authService: AuthServicing
    let onAuthenticated: () -> Void
    let onBack: () -> Void
    let onForgotPassword: () -> Void

    @MainActor
    func makeView() -> some View {
        let viewModel = LogInViewModel(
            authService: authService,
            onAuthenticated: onAuthenticated,
            onBack: onBack,
            onForgotPassword: onForgotPassword
        )
        return LogInView(viewModel: viewModel)
    }
}
