//
//  RootCoordinator.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 27/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class RootCoordinator: Coordinator<UIWindow> {

    // MARK: - Start

    override func start() {
        let navigationController = UINavigationController()
        rootView.rootViewController = navigationController
        let coordinator = LaunchCoordinator(rootView: navigationController)
        add(children: coordinator)
        rootView.makeKeyAndVisible()
        coordinator.start()
    }
}
