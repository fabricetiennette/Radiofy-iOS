//
//  LaunchCoordinator.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 27/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import SwiftUI

class LaunchCoordinator: Coordinator<UINavigationController> {

    // MARK: - Start

    private var needAnimation: Bool

    init(rootView: UINavigationController, needAnimation: Bool) {
        self.needAnimation = needAnimation
        super.init(rootView: rootView)
    }

    override func start() {
        let module = LaunchModule(coordinatorDelegate: self, needAnimation: needAnimation)
        let hostingController = UIHostingController(rootView: module.launchView)
        rootView.setNavigationBarHidden(true, animated: true)
        rootView.pushViewController(hostingController, animated: false)
    }
}

extension LaunchCoordinator: LaunchModule.CoordinatorDelegate {

    func showOnboardingPath() {
        let coordinator = OnBoardingCoordinator(rootView: rootView)
        add(children: coordinator)
        coordinator.start()
    }

    func showHomeTabBar() {
        let coordinator = TabBarCoordinator(rootView: rootView)
        add(children: coordinator)
        coordinator.start()
    }
}
