//
//  SearchCoordinator.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 01/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class SearchCoordinator {

    // MARK: - Properties

        let navigationController = UINavigationController()

        // MARK: - Coordinator

    func start() {
        let viewController = SearchViewController.instantiate(from: "Search")
        let viewModel = SearchViewModel(delegate: self)
        viewController.viewModel = viewModel
        viewController.tabBarItem = UITabBarItem(
            title: L1s.searchTitleTab,
            image: UIImage(named: "SearchIcon"),
            selectedImage: UIImage(named: "SearchIconFill")
        )
        navigationController.viewControllers = [viewController]
    }

    // Make radio profile page
    private func makeRadioPage(with selectedRadio: RadioStation) {
        let viewController = RadioViewController.instantiate(from: "Radio")
        let viewModel = RadioViewModel(delegate: self, selectedRadio: selectedRadio)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }

    private func makePayWallView() {
        let viewController = SubscriptionViewController.instantiate(from: "Subscription")
        let viewModel = SubscriptionViewModel(delegate: self)
        viewController.viewModel = viewModel
        viewController.modalPresentationStyle = .fullScreen
        navigationController.present(viewController, animated: true, completion: nil)
    }

    private func makeSignUpView() {
        let viewController = SignUpViewController.instantiate(from: "Start")
        let viewModel = SignUpViewModel(delegate: self)
        viewController.viewModel = viewModel
        viewController.navigationItem.title = L1s.creatAccount
        navigationController.pushViewController(viewController, animated: true)
    }

    private func launchHomeView() {
        let main = MainTabBarController()
        let radioPlayer = RadioPlayerCoordinator(tabBarController: main)
        navigationController.view.window?.rootViewController = main
        navigationController.view.window?.makeKeyAndVisible()
        radioPlayer.start()
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
