//
//  MainCoordinator.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 27/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainCoordinator: Coordinator<UINavigationController> {

    // MARK: - Start
    private let auth = Auth.auth()

    override func start() {
        addObserver()
        setFirebaseEmailLanguage()
        isUserLoggedIn()
    }

    // MARK: - Private

    private func isUserLoggedIn() {
        if auth.currentUser != nil {
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
        let startCoordinator = StartCoordinator(navigationController: rootView)
        LaunchScreenManager.instance.animateAfterLaunch(
            rootView.view
        )
        startCoordinator.start()
    }

    private func callMainTabBar() {
        let coordinator = TabBarCoordinator(rootView: rootView)
        LaunchScreenManager.instance.animateAfterLaunch(
            self.rootView.view
        )
        add(children: coordinator)
        coordinator.start()
    }

    private func setFirebaseEmailLanguage() {
        let language = Locale.preferredLanguages.first
        auth.languageCode = language
    }
}
