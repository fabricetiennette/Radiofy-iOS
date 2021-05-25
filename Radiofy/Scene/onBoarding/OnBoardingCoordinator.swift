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
        launchOnboarding()
    }

    // MARK: - Private

    private func launchOnboarding() {
        let module = OnBoardingModule(coordinatorDelegate: self)
        let viewController = module.viewController
        viewController.setNavigationBackButton(image: UIImage(named: "BackIcon"), state: .normal)
        viewController.setUIBarButtonItem(style: .plain)
        rootView.viewControllers = [viewController]
    }

    private func goToSignUpView() {
        let coordinator = SignUpCoordinator(options: .push(rootView))
        rootView.setNavigationBarHidden(false, animated: false)
        coordinator.delegate = self
        add(children: coordinator)
        coordinator.start()
    }

    private func goToLogInView() {
        let coordinator = LogInCoordinator(options: .push(rootView))
        rootView.setNavigationBarHidden(false, animated: false)
        coordinator.delegate = self
        add(children: coordinator)
        coordinator.start()
//        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(
//            title: nil,
//            style: .plain,
//            target: nil,
//            action: nil
//        )
    }

    private func makePasswordResetView() {
        let viewController = PasswordResetViewController.instantiate(from: .start)
        let viewModel = PasswordResetViewModel()
        viewController.viewModel = viewModel
        viewController.navigationItem.title = L1s.resetPasswordTab
        rootView.pushViewController(viewController, animated: true)
    }

    private func launchHome() {
        let coordinator = LaunchCoordinator(rootView: rootView, needAnimation: false)
        add(children: coordinator)
        coordinator.start()
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

    func goToLogIn() {
        goToLogInView()
    }

    func goToSignUp() {
        goToSignUpView()
    }

    func goToSignIn() {
        launchHome()
    }
}

extension OnBoardingCoordinator: SignUpCoordinatorDelegate {
    func goHomeFromSignUp() {
        launchHome()
    }
}

extension OnBoardingCoordinator: LogInCoordinatorDelegate {
    func goHomeFromLogIn() {
        launchHome()
    }

    func launchPasswordReset() {
        makePasswordResetView()
    }
}
