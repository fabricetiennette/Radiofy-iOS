//
//  OnBoardingModule.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 10/05/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import UIKit

struct OnBoardingModule {

    typealias ViewModel = OnBoardingOutputBinding
    typealias Service = OnBoardingServiceProtocol
    typealias CoordinatorDelegate = OnBoardingViewModelDelegate

    // swiftlint:disable:next weak_delegate
    private let coordinatorDelegate: CoordinatorDelegate

    init(coordinatorDelegate: CoordinatorDelegate) {
        self.coordinatorDelegate = coordinatorDelegate
    }

    var viewController: UIViewController {
        let service = OnBoardingService()
        let viewModel = OnBoardingViewModel(service: service)
        let onBoardingViewController = OnBoardingViewController(viewModel: viewModel)
        viewModel.delegate = coordinatorDelegate
        return onBoardingViewController
    }
}

protocol OnBoardingOutputBinding {
    func openSignUpView()
    func openLogInView()
    func signInAnonymously()
    var errorHandler: ((_ title: String, _ message: String) -> Void) { get set }
}

protocol OnBoardingServiceProtocol {
    func signInAnonymously(callback: @escaping (AuthResult) -> Void)
}
protocol OnBoardingViewModelDelegate: AnyObject {
    func signUp()
    func logIn()
    func signIn()
}
