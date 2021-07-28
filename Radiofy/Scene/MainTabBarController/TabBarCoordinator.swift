//
//  TabBarCoordinator.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 25/04/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import Foundation
import UIKit

class TabBarCoordinator: Coordinator<UINavigationController> {

    override func start() {
        let tabBarController = MainTabBarController()
        tabBarController.coordinator = self

        // HomeController
        let homeNavController = UINavigationController()
        homeNavController.setNavigationBarHidden(true, animated: false)
        homeNavController.tabBarItem = UITabBarItem(
            title: L1s.homeTitle,
            image: UIImage(named: "HomeIcon"),
            selectedImage: UIImage(named: "HomeIconFill")
        )
        let homeCoordinator = HomeCoordinator(options: .push(homeNavController))

        // SearchController
        let searchNavController = UINavigationController()
        searchNavController.tabBarItem = UITabBarItem(
            title: L1s.searchTitleTab,
            image: UIImage(named: "SearchIcon"),
            selectedImage: UIImage(named: "SearchIconFill")
        )
        let searchCoordinator = SearchCoordinator(options: .push(searchNavController))

        // LibraryController
        let libraryNavController = UINavigationController()
        libraryNavController.tabBarItem = UITabBarItem(
            title: L1s.yourLibraryTitleTab,
            image: UIImage(named: "YourLibraryIcon"),
            selectedImage: UIImage(named: "YourLibraryIconFill")
        )
        let libraryCoordinator = YourLibraryCoordinator(options: .push(libraryNavController))

        // PodcastController
        let podcastNavController = UINavigationController()
        podcastNavController.tabBarItem = UITabBarItem(
            title: "Podcast",
            image: UIImage(named: "podcastsLogo"),
            selectedImage: UIImage(named: "podcastsFilled")
        )
        let podcastCoordinator = PodcastCoordinator(options: .push(podcastNavController))

        tabBarController.viewControllers = [homeNavController, searchNavController, libraryNavController, podcastNavController]

        self.rootView.setNavigationBarHidden(true, animated: false)
        self.rootView.pushViewController(tabBarController, animated: false)

        add(children: homeCoordinator)
        add(children: searchCoordinator)
        add(children: libraryCoordinator)
        add(children: podcastCoordinator)

        homeCoordinator.start()
        searchCoordinator.start()
        libraryCoordinator.start()
        podcastCoordinator.start()

        let radioPlayer = RadioPlayerCoordinator(rootView: tabBarController)
        add(children: radioPlayer)
        radioPlayer.start()
    }
}
