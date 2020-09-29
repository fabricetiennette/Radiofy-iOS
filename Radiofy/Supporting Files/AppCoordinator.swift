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
import GoogleMobileAds
import Purchases

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
        isUserPremium()
        IQKeyboardManager.shared.enable = true
        mainCoordinator = MainCoordinator(presenter: appDelegate.window!)
        mainCoordinator?.start()
    }

    private func isUserPremium() {
        configurePurchases()
        Purchases.shared.purchaserInfo { purchaserInfo, _ in
            if purchaserInfo?.entitlements["Premium"]?.isActive == false {
                self.configureAddMob()
            }
        }
    }

    private func configureAddMob() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }

    private func configurePurchases() {
        Purchases.debugLogsEnabled = true
        Purchases.configure(withAPIKey: "NShPdrfWROxxEWZZPvYqtjztEkkwTiIX")
    }
}
