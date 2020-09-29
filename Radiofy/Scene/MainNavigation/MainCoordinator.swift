//
//  MainCoordinator.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 27/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainCoordinator {

    // MARK: - Properties

    private let presenter: UIWindow

    private let navigationController: UINavigationController

    private var startCoordinator: StartCoordinator?

    private var mainTabBarController: MainTabBarController?

    private var radioPlayer: RadioPlayerCoordinator?

    private let firebaseAuth: Auth

    // MARK: - Properties

    init(presenter: UIWindow, firebaseAuth: Auth = Auth.auth()) {
        self.presenter = presenter
        self.firebaseAuth = firebaseAuth

        navigationController = UINavigationController()
        addObserver()
        setFirebaseEmailLanguage()
    }

    // MARK: - Start

    func start() {
        isUserLoggedIn()
    }

    // MARK: - Private

    private func isUserLoggedIn() {
        if firebaseAuth.currentUser != nil {
            callMainTabBar()
        } else {
            callRegistrationAndLoginPath()
        }
    }

    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(showStartAfterSignOut(notification:)), name: SettingsViewModel.NotificationDone, object: nil)
    }

    @objc private func showStartAfterSignOut(notification: Notification) {
        isUserLoggedIn()
    }

    private func callRegistrationAndLoginPath() {
        startCoordinator = StartCoordinator(navigationController: navigationController)
        presenter.rootViewController = navigationController
        LaunchScreenManager.instance.animateAfterLaunch(
           presenter.rootViewController?.view
        )
        startCoordinator?.start()
    }

    private func callMainTabBar() {
        mainTabBarController = MainTabBarController()
        presenter.rootViewController = mainTabBarController
        callRadioPlayer(mainTabBarController: mainTabBarController!)
        LaunchScreenManager.instance.animateAfterLaunch(
           presenter.rootViewController?.view
        )
    }

    private func callRadioPlayer(mainTabBarController: UITabBarController) {
        radioPlayer = RadioPlayerCoordinator(tabBarController: mainTabBarController)
        radioPlayer?.start()
    }

    private func setFirebaseEmailLanguage() {
        let language = Locale.preferredLanguages.first
        firebaseAuth.languageCode = language
    }
}
