//
//  PasswordResetCoordinator.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 29/05/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import UIKit

final class PasswordResetCoordinator: Coordinator<UIViewController> {

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

    override func start() {
        let module = PasswordResetModule()
        let passwordResetViewController = module.viewController
        passwordResetViewController.navigationItem.title = L10n.resetPassword

        switch options {
        case let .present(viewController, style: style):
            let navigationController = UINavigationController(rootViewController: passwordResetViewController)
            navigationController.modalPresentationStyle = style
            viewController.present(passwordResetViewController, animated: true)

        case let .push(navigationController):
            navigationController.pushViewController(passwordResetViewController, animated: true)
        }
    }
}
