//
//  AppCoordinator.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 27/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class RootCoordinator: Coordinator<UIWindow> {

    // MARK: - Initializer

    override func start() {
        configureFirebase()
        let navigationController = UINavigationController()
        rootView.rootViewController = navigationController
        let coordinator = LaunchCoordinator(rootView: navigationController)
        add(children: coordinator)
        rootView.makeKeyAndVisible()
        coordinator.start()
    }
}

    // MARK: - Private extension

private extension RootCoordinator {

    func configureFirebase() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
    }
}
