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

class AppCoordinator {

    // MARK: - Properties

    private unowned var appDelegate: AppDelegate

    private var mainCoordinator: MainCoordinator?

    // MARK: - Initializer

       init(appDelegate: AppDelegate) {
           self.appDelegate = appDelegate
       }

    // MARK: - Start

    func start() {
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window!.makeKeyAndVisible()
        showMain()
    }
}

extension AppCoordinator {

    // MARK: - Private

    private func showMain() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        mainCoordinator = MainCoordinator(presenter: appDelegate.window!)
        mainCoordinator?.start()
    }
}
