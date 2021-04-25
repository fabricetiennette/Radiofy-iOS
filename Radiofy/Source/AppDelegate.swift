//
//  AppDelegate.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 23/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var rootCoordinator: CoordinatorType?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        rootCoordinator = RootCoordinator(rootView: window)
        rootCoordinator?.start()
        return true
    }
}
