//
//  SignUpCoordinator.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 17/05/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import Foundation
import UIKit

protocol SignUpCoordinatorDelegate: CoordinatorDelegate {
    func goHomeFromSignUp()
}

class SignUpCoordinator: Coordinator<UIViewController> {

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

    weak var delegate: SignUpCoordinatorDelegate?

    override func start() {
//        let module = SignUpModule(coordinatorDelegate: self)
//        let signUpViewController = module.viewController
//        signUpViewController.navigationItem.title = L10n.createAccount
//
//        switch options {
//        case let .present(viewController, style: style):
//            let navigationController = UINavigationController(rootViewController: signUpViewController)
//            navigationController.modalPresentationStyle = style
//            viewController.present(signUpViewController, animated: true)
//
//        case let .push(navigationController):
//            navigationController.pushViewController(signUpViewController, animated: true)
//        }
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

//extension SignUpCoordinator: SignUpModule.CoordinatorDelegate {
//    func didTapOnBack() {
//        finish()
//    }
//
//    func goToHomeView() {
//        delegate?.goHomeFromSignUp()
//    }
//}
