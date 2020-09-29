//
//  YourLibraryCoordinator.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 01/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class YourLibraryCoordinator {

    // MARK: - Properties

        let navigationController = UINavigationController()

    // MARK: - Coordinator

    func start() {
        let viewController = YourLibraryViewController.instantiate(from: "Library")
        let viewModel = YourLibraryViewModel(delegate: self)
        viewController.viewModel = viewModel
        viewController.tabBarItem = UITabBarItem(
            title: L1s.yourLibraryTitleTab,
            image: UIImage(named: "YourLibraryIcon"),
            selectedImage: UIImage(named: "YourLibraryIconFill")
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

// Conform to protocol from YourLibraryViewModel
extension YourLibraryCoordinator: YourLibraryViewModelDelegate {
    func selectRadio(_ selectedradio: RadioStation) {
        makeRadioPage(with: selectedradio)
    }
}

extension YourLibraryCoordinator: RadioViewModelDelegate {
    func openPayWallView() {
        makePayWallView()
    }
}

extension YourLibraryCoordinator: SubscriptionViewModelDelegate {
    func signUpFirst() {
        makeSignUpView()
    }
}

extension YourLibraryCoordinator: SignUpViewModelDelegate {
    func callhomeScreen() {
        launchHomeView()
    }
}
