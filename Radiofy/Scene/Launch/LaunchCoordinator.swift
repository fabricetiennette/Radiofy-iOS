//
//  LaunchCoordinator.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 27/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class LaunchCoordinator: Coordinator<UINavigationController> {

    // MARK: - Start

    override func start() {
        let launchViewController = LaunchModule(coordinatorDelegate: self).viewController
        rootView.pushViewController(launchViewController, animated: true)
    }
}

extension LaunchCoordinator: LaunchModule.CoordinatorDelegate {

    func showOnboardingPath() {
        let startCoordinator = StartCoordinator(rootView: rootView)
        LaunchScreenManager.instance.animateAfterLaunch(
            rootView.view
        )
        add(children: startCoordinator)
        startCoordinator.start()
    }

    func showHomeTabBar() {
        let coordinator = TabBarCoordinator(rootView: rootView)
        LaunchScreenManager.instance.animateAfterLaunch(
            self.rootView.view
        )
        add(children: coordinator)
        coordinator.start()
    }
}
