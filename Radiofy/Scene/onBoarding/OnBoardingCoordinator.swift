//
//  OnBoardingCoordinator.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 27/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class OnBoardingCoordinator: Coordinator<UINavigationController> {

    // MARK: - Coordinator

    override func start() {
        rootView.navigationBar.barStyle = .black
        rootView.navigationBar.isTranslucent = false
        rootView.navigationBar.tintColor = .white
        rootView.navigationBar.shadowImage = UIImage()
        showStartingView()
    }

    // MARK: - Private

    private func showStartingView() {
        let viewController = OnBoardingViewController.instantiate(from: "Start")
        let viewModel = OnBoardingViewModel(delegate: self)
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
        rootView.viewControllers = [viewController]
    }

    private func makeSignUpView() {
        let viewController = SignUpViewController.instantiate(from: "Start")
        let viewModel = SignUpViewModel(delegate: self)
        viewController.viewModel = viewModel
        viewController.navigationItem.title = L1s.creatAccount
        rootView.pushViewController(viewController, animated: true)
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
        rootView.pushViewController(viewController, animated: true)
    }

    private func makePasswordResetView() {
        let viewController = PasswordResetViewController.instantiate(from: "Start")
        let viewModel = PasswordResetViewModel()
        viewController.viewModel = viewModel
        viewController.navigationItem.title = L1s.resetPasswordTab
        rootView.pushViewController(viewController, animated: true)
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

extension OnBoardingCoordinator: OnBoardingViewModelDelegate {
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

extension OnBoardingCoordinator: SignUpViewModelDelegate {
    func callhomeScreen() {
        launchHomeView()
    }
}

extension OnBoardingCoordinator: LogInViewModelDelegate {
    func launchPasswordReset() {
        makePasswordResetView()
    }

    func launchHomeScreen() {
        launchHomeView()
    }
}
