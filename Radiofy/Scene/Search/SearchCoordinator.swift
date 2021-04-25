//
//  SearchCoordinator.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 01/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class SearchCoordinator: Coordinator<UINavigationController> {

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
        let viewController = SearchViewController.instantiate(from: "Search")
        let viewModel = SearchViewModel(delegate: self)
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

    // Make radio profile page
    private func makeRadioPage(with selectedRadio: RadioStation) {
        let viewController = RadioViewController.instantiate(from: "Radio")
        let viewModel = RadioViewModel(delegate: self, selectedRadio: selectedRadio)
        viewController.viewModel = viewModel
        rootView.pushViewController(viewController, animated: true)
    }

    private func makePayWallView() {
        let viewController = SubscriptionViewController.instantiate(from: "Subscription")
        let viewModel = SubscriptionViewModel(delegate: self)
        viewController.viewModel = viewModel
        viewController.modalPresentationStyle = .fullScreen
        rootView.present(viewController, animated: true, completion: nil)
    }

    private func makeSignUpView() {
        let viewController = SignUpViewController.instantiate(from: "Start")
        let viewModel = SignUpViewModel(delegate: self)
        viewController.viewModel = viewModel
        viewController.navigationItem.title = L1s.creatAccount
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

extension SearchCoordinator: SearchViewModelDelegate {
    func selectRadio(_ selectedradio: RadioStation) {
        makeRadioPage(with: selectedradio)
    }
}

extension SearchCoordinator: RadioViewModelDelegate {
    func openPayWallView() {
        makePayWallView()
    }
}

extension SearchCoordinator: SubscriptionViewModelDelegate {
    func signUpFirst() {
        makeSignUpView()
    }
}

extension SearchCoordinator: SignUpViewModelDelegate {
    func callhomeScreen() {
        launchHomeView()
    }
}
