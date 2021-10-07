//
//  HomeCoordinator.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 28/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class HomeCoordinator: Coordinator<UINavigationController> {

    enum Options {
        case push(UINavigationController)
    }

    private let options: Options

    init(options: Options) {
        self.options = options
        switch options {
        case let .push(navigationController):
            super.init(rootView: navigationController)
        }
    }

    // MARK: - start

    override func start() {
        let module = HomeModule(coordinatorDelegate: self)
        let homeViewController = module.viewController

        switch options {
        case let .push(navigationController):
            navigationController.pushViewController(homeViewController, animated: true)
        }
    }

    // MARK: - Private

    private func goToSettings() {
        let coordinator = SettingsCoordinator(options: .push(rootView))
        rootView.setNavigationBarHidden(false, animated: false)
        coordinator.delegate = self
        add(children: coordinator)
        coordinator.start()
    }

    private func makeEditProfilePage() {
        let viewController = EditProfileViewController.instantiate(from: .home)
        let viewModel = EditProfileViewModel()
        viewController.viewModel = viewModel
        viewController.modalPresentationStyle = .formSheet
        let editProfile = UINavigationController(rootViewController: viewController)
        rootView.present(editProfile, animated: true)
    }

    private func goToRadio(with radio: RadioStation) {
        let coordinator = RadioCoordinator(options: .push(rootView), radio: radio)
        add(children: coordinator)
        coordinator.start()
    }

    private func makeAboutPage() {
        let viewController = AboutViewController.instantiate(from: .home)
        let viewModel = AboutViewModel()
        viewController.viewModel = viewModel
        rootView.pushViewController(viewController, animated: true)
    }

    private func makeAccountPage() {
        let viewController = AccountViewController.instantiate(from: .home)
        let viewModel = AccountViewModel(delegate: self)
        viewController.viewModel = viewModel
        rootView.pushViewController(viewController, animated: true)
    }

    private func goToSignUpView() {
        let coordinator = LogInCoordinator(options: .push(rootView))
        rootView.setNavigationBarHidden(false, animated: false)
        coordinator.delegate = self
        add(children: coordinator)
        coordinator.start()
    }

    private func makePayWallView() {
        let viewController = SubscriptionViewController.instantiate(from: .subscription)
        let viewModel = SubscriptionViewModel(delegate: self)
        viewController.viewModel = viewModel
        viewController.modalPresentationStyle = .fullScreen
        rootView.present(viewController, animated: true, completion: nil)
    }
}

extension HomeCoordinator: HomeModule.CoordinatorDelegate {
    func showPayWall() {
        makePayWallView()
    }

    func showSelectedRadio(_ radio: RadioStation) {
        goToRadio(with: radio)
    }

    func launchSettings() {
        goToSettings()
    }
}

extension HomeCoordinator: SettingsCoordinatorDelegate {
    func goToCreateAccount() {
        goToSignUpView()
    }

    func goToAccountPage() {
        makeAccountPage()
    }

    func goToAboutPage() {
        makeAboutPage()
    }

    func goToEditProfile() {
        makeEditProfilePage()
    }
}

extension HomeCoordinator: AccountViewModelDelete {
    func showSubscriptionPage() {
        makePayWallView()
    }
}

extension HomeCoordinator: LogInCoordinatorDelegate {
    func goHomeFromLogIn() {

    }

    func goPasswordReset() {

    }
}

extension HomeCoordinator: SubscriptionViewModelDelegate {
    func signUpFirst() {
        goToSignUpView()
    }
}
