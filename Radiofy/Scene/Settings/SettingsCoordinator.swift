//
//  SettingsCoordinator.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 31/07/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import UIKit

class SettingsCoordinator: Coordinator<UIViewController> {

    enum Options {
        case present(UIViewController, style: UIModalPresentationStyle)
        case push(UINavigationController)
    }

    private let options: Options

    init(options: Options) {
        self.options = options
        switch options {
        case let .present(viewController, style: _):
            super.init(rootView: viewController)
        case let .push(navigationController):
            super.init(rootView: navigationController)
        }
    }

    weak var delegate: SettingsCoordinatorDelegate?

    override func start() {
        let module = SettingsModule(coordinatorDelegate: self)
        let settingsViewController = module.viewController
        settingsViewController.navigationItem.title = L10n.createAccount

        switch options {
        case let .present(viewController, style: style):
            let navigationController = UINavigationController(rootViewController: settingsViewController)
            navigationController.modalPresentationStyle = style
            viewController.present(settingsViewController, animated: true)

        case let .push(navigationController):
            navigationController.pushViewController(settingsViewController, animated: true)
        }
    }

    private func finish() {
        switch options {
        case let .present(viewController, style: _):
            viewController.dismiss(animated: true)
        case let .push(navigationController):
            navigationController.popViewController(animated: true)
        }

        delegate?.finish(from: self)
    }
}

extension SettingsCoordinator: SettingsModule.CoordinatorDelegate {

    func editProfile() {
        delegate?.goToEditProfile()
    }

    func accountPage() {
        delegate?.goToAccountPage()
    }

    func aboutPage() {
        delegate?.goToAboutPage()
    }

    func createAccount() {
        delegate?.goToCreateAccount()
    }
}
