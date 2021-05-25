//
//  LoginCoordinator.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 25/05/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import Foundation
import UIKit

protocol LogInCoordinatorDelegate: CoordinatorDelegate {
    func goHomeFromLogIn()
}

class LogInCoordinator: Coordinator<UIViewController> {

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

    weak var delegate: LogInCoordinatorDelegate?

    override func start() {
        let module = LogInModule(coordinatorDelegate: self)
        let logInViewController = module.viewController
        logInViewController.navigationItem.title = L1s.logInTab

        switch options {
        case let .present(viewController, style: style):
            let navigationController = UINavigationController(rootViewController: logInViewController)
            navigationController.modalPresentationStyle = style
            viewController.present(logInViewController, animated: true)

        case let .push(navigationController):
            navigationController.pushViewController(logInViewController, animated: true)
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

extension LogInCoordinator: LogInModule.CoordinatorDelegate {
    func didTapOnBack() {
        finish()
    }

    func goToHomeView() {
        delegate?.goHomeFromLogIn()
    }

    func launchPasswordReset() {

    }
}
