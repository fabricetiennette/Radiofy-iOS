//
//  YourLibraryCoordinator.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 01/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class YourLibraryCoordinator: Coordinator<UINavigationController> {

    // MARK: - Properties

    enum Options {
        case present(UINavigationController, style: UIModalPresentationStyle)
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

    // MARK: - Coordinator

    override func start() {
        let module = YourLibraryModule(coordinatorDelegate: self)
        let yourLibraryViewController = module.viewController

        switch self.options {
        case let .present(vc, style):
            let navigationController = UINavigationController(rootViewController: yourLibraryViewController)
            navigationController.modalPresentationStyle = style
            vc.present(navigationController, animated: true)
        case let .push(navigationController):
            navigationController.pushViewController(yourLibraryViewController, animated: true)
        }
    }

    // Make radio profile page
    private func goToRadio(with radio: RadioStation) {
        let coordinator = RadioCoordinator(options: .push(rootView), radio: radio)
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

    private func makeSignUpView() {
//        let viewController = SignUpViewController.instantiate(from: "Start")
//        let viewModel = SignUpViewModel(delegate: self)
//        viewController.viewModel = viewModel
//        viewController.navigationItem.title = L10n.createAccount
//        rootView.pushViewController(viewController, animated: true)
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

// Conform to protocol from YourLibraryViewModel
extension YourLibraryCoordinator: YourLibraryModule.CoordinatorDelegate {
    func selectRadio(_ radio: RadioStation) {
        goToRadio(with: radio)
    }
}

extension YourLibraryCoordinator: SubscriptionViewModelDelegate {
    func signUpFirst() {
        makeSignUpView()
    }
}

//extension YourLibraryCoordinator: SignUpViewModelDelegate {
//    func didTapOnBack() {
//
//    }
//
//    func goToHomeView() {
//        launchHomeView()
//    }
//}
