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
        startOnboardingView()
    }

    // MARK: - Private

    private func startOnboardingView() {
        let viewController = OnBoardingModule(coordinatorDelegate: self).viewController
        viewController.setNavigationBackButton(image: UIImage(named: "BackIcon"), state: .normal)
        viewController.setUIBarButtonItem(style: .plain)
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
        let launchViewController = LaunchModule(coordinatorDelegate: self, needAnimation: false).viewController
        rootView.setNavigationBarHidden(true, animated: true)
        rootView.pushViewController(launchViewController, animated: false)
    }
}

    // MARK: - Extension

extension OnBoardingCoordinator: LaunchModule.CoordinatorDelegate {

    func showOnboardingPath() {
        let coordinator = OnBoardingCoordinator(rootView: rootView)
        add(children: coordinator)
        coordinator.start()
    }

    func showHomeTabBar() {
        let coordinator = TabBarCoordinator(rootView: rootView)
        add(children: coordinator)
        coordinator.start()
    }
}

extension OnBoardingCoordinator: OnBoardingModule.CoordinatorDelegate {

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
