//
//  HomeCoordinator.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 28/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class HomeCoordinator: Coordinator<UINavigationController> {

    // MARK: - Properties

    enum Options {
        case present(UINavigationController, style: UIModalPresentationStyle)
        case push(UINavigationController)
    }

    private let options: Options

//    let navigationController: UINavigationController

    // MARK: - Initializer

    init(options: Options) {
        self.options = options
        switch options {
        case let .present(viewController, style: _):
            super.init(rootView: viewController)
        case let .push(navigationController):
            super.init(rootView: navigationController)
        }
    }

    // MARK: - Coordinator

    override func start() {
       let viewController = HomeViewController.instantiate(from: "Home")
        let viewModel = HomeViewModel(delegate: self)
        viewController.viewModel = viewModel

        switch self.options {
        case let .present(vc, style):
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = style
            vc.present(navigationController, animated: true)
        case let .push(navigationController):
            navigationController.pushViewController(viewController, animated: true)
        }
    }

    private func makeSettingsPage() {
        let viewController = SettingsViewController.instantiate(from: "Home")
        let viewModel = SettingsViewModel(delegate: self)
        viewController.viewModel = viewModel
        rootView.pushViewController(viewController, animated: true)
    }

    private func makeEditProfilePage() {
        let viewController = EditProfileViewController.instantiate(from: "Home")
        let viewModel = EditProfileViewModel()
        viewController.viewModel = viewModel
        viewController.modalPresentationStyle = .formSheet
        let editProfile = UINavigationController(rootViewController: viewController)
        rootView.present(editProfile, animated: true)
    }

    private func makeRadioPage(with selectedRadio: RadioStation) {
        let viewController = RadioViewController.instantiate(from: "Radio")
        let viewModel = RadioViewModel(delegate: self, selectedRadio: selectedRadio)
        viewController.viewModel = viewModel
        rootView.pushViewController(viewController, animated: true)
    }

    private func makeAboutPage() {
        let viewController = AboutViewController.instantiate(from: "Home")
        let viewModel = AboutViewModel()
        viewController.viewModel = viewModel
        rootView.pushViewController(viewController, animated: true)
    }

    private func makeAccountPage() {
        let viewController = AccountViewController.instantiate(from: "Home")
        let viewModel = AccountViewModel(delegate: self)
        viewController.viewModel = viewModel
        rootView.pushViewController(viewController, animated: true)
    }

    private func makeSignUpView() {
        let viewController = SignUpViewController.instantiate(from: "Start")
        let viewModel = SignUpViewModel(delegate: self)
        viewController.viewModel = viewModel
        viewController.navigationItem.title = L1s.creatAccount
        rootView.pushViewController(viewController, animated: true)
    }

    private func makePayWallView() {
        let viewController = SubscriptionViewController.instantiate(from: "Subscription")
        let viewModel = SubscriptionViewModel(delegate: self)
        viewController.viewModel = viewModel
        viewController.modalPresentationStyle = .fullScreen
        rootView.present(viewController, animated: true, completion: nil)
    }
}

extension HomeCoordinator: HomeViewModelDelegate {
    func showPayWall() {
        makePayWallView()
    }

    func showSelectedRadio(_ selectedRadio: RadioStation) {
        makeRadioPage(with: selectedRadio)
    }

    func launchSettings() {
        makeSettingsPage()
    }
}

extension HomeCoordinator: SettingsViewModelDelegate {
    func createAccount() {
        makeSignUpView()
    }

    func callAccountPage() {
        makeAccountPage()
    }

    func callAboutPage() {
        makeAboutPage()
    }

    func callEditProfile() {
        makeEditProfilePage()
    }
}

extension HomeCoordinator: AccountViewModelDelete {
    func showSubscriptionPage() {
        makePayWallView()
    }
}

extension HomeCoordinator: SignUpViewModelDelegate {
    func callhomeScreen() {
        start()
    }
}

extension HomeCoordinator: SubscriptionViewModelDelegate {
    func signUpFirst() {
        makeSignUpView()
    }
}

extension HomeCoordinator: RadioViewModelDelegate {
    func openPayWallView() {
        makePayWallView()
    }
}
