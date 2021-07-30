//
//  OnBoardingModule.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 10/05/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import UIKit
import Combine

struct OnBoardingModule {

    typealias ViewModel = OnBoardingOutputBinding & OnBoardingInputBinding
    typealias Service = OnBoardingServiceProtocol
    typealias CoordinatorDelegate = OnBoardingViewModelDelegate

    private weak var coordinatorDelegate: CoordinatorDelegate?

    init(coordinatorDelegate: CoordinatorDelegate?) {
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
    var errorPublisher: PassthroughSubject<(String, String), Never> { get set }
}

protocol OnBoardingInputBinding {
    func didTapSignUp()
    func didTapLogIn()
    func didTapSignInAnonymously()
}

protocol OnBoardingServiceProtocol {
    func signInAnonymously() -> AnyPublisher<UserProtocol, Error>
}

protocol OnBoardingViewModelDelegate: AnyObject {
    func goToSignUp()
    func goToLogIn()
    func goToSignIn()
}
