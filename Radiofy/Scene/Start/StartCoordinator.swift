//
//  StartCoordinator.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 27/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class StartCoordinator {

    // MARK: - Properties

    let navigationController: UINavigationController

    // MARK: - Initializer

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController

        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.shadowImage = UIImage()
    }

    // MARK: - Coordinator

    func start() {
        showStartingView()
    }

    // MARK: - Private

    private func showStartingView() {
        let viewController = StartViewController.instantiate(from: "Start")
        let viewModel = StartViewModel(delegate: self)
        viewController.viewModel = viewModel
        viewController.navigationItem.backBarButtonItem?.setBackButtonBackgroundImage(
            UIImage(named: "BackIcon"),
            for: .normal,
            barMetrics: .default
        )
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: nil,
            style: .plain,
            target: nil,
            action: nil
        )
        navigationController.viewControllers = [viewController]
    }

    private func makeSignUpView() {
        let viewController = SignUpViewController.instantiate(from: "Start")
        let viewModel = SignUpViewModel(delegate: self)
        viewController.viewModel = viewModel
        viewController.navigationItem.title = L1s.creatAccount
        navigationController.pushViewController(viewController, animated: true)
    }

    private func makeLogInView() {
        let viewController = LogInViewController.instantiate(from: "Start")
        let viewModel = LogInViewModel(delegate: self)
        viewController.viewModel = viewModel
        viewController.navigationItem.title = L1s.logInTab
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: nil,
            style: .plain,
            target: nil,
            action: nil
        )
        navigationController.pushViewController(viewController, animated: true)
    }

    private func makePasswordResetView() {
        let viewController = PasswordResetViewController.instantiate(from: "Start")
        let viewModel = PasswordResetViewModel()
        viewController.viewModel = viewModel
        viewController.navigationItem.title = L1s.resetPasswordTab
        navigationController.pushViewController(viewController, animated: true)
    }

    private func launchHomeView() {
//        let rootView = UITabBarController()
//        let main = MainTabBarController(rootView: rootView)
//        let radioPlayer = RadioPlayerCoordinator(rootView: main)
//        navigationController.view.window?.rootViewController = main
//        navigationController.view.window?.makeKeyAndVisible()
//        radioPlayer.start()
    }
}

    // MARK: - Extension

extension StartCoordinator: StartViewModelDelegate {
    func logIn() {
        makeLogInView()
    }

    func signUp() {
        makeSignUpView()
    }

    func signIn() {
        launchHomeView()
    }
}

extension StartCoordinator: SignUpViewModelDelegate {
    func callhomeScreen() {
        launchHomeView()
    }
}

extension StartCoordinator: LogInViewModelDelegate {
    func launchPasswordReset() {
        makePasswordResetView()
    }

    func launchHomeScreen() {
        launchHomeView()
    }
}
