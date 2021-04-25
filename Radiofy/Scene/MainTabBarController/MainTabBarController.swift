//
//  MainTabBarController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 31/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    var coordinator: TabBarCoordinator?

    override func viewDidLoad() {
        self.tabBar.barTintColor = UIColor(cgColor: #colorLiteral(red: 0.156845212, green: 0.1568739116, blue: 0.1568388939, alpha: 1))
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = .white
    }

    private var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 0.6, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = 0.3
        bounceAnimation.calculationMode = .linear
        return bounceAnimation
    }()

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard
            let index = tabBar.items?.firstIndex(of: item),
            tabBar.subviews.count > index + 1,
            let imageView = tabBar.subviews[index + 1].subviews.first as? UIImageView
            else {
                return
        }
        imageView.layer.add(bounceAnimation, forKey: nil)
    }
}

extension MainTabBarController: Storyboarded {}
