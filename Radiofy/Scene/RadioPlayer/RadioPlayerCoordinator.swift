//
//  RadioPlayerCoordinator.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 10/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import LNPopupController

class RadioPlayerCoordinator {

    private let tabBarController: UITabBarController

    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }

    func start() {
        let viewController = MiniPlayerViewController.instantiate(from: "Player")
        let radioPlayerVC = makeRadioPlayerViewController()
        let viewModel = MiniPlayerViewModel(view: radioPlayerVC)
        viewController.viewModel = viewModel
        tabBarController.popupBar.customBarViewController = viewController
        tabBarController.popupContentView.popupCloseButtonStyle = .none
        tabBarController.popupInteractionStyle = .drag
        tabBarController.presentPopupBar(
            withContentViewController: radioPlayerVC,
            animated: false,
            completion: nil
        )
    }

    private func makeRadioPlayerViewController() -> RadioPlayerViewController {
        let viewController = RadioPlayerViewController.instantiate(from: "Player")
        let viewModel = RadioPlayerViewModel(delegate: self)
        viewController.viewModel = viewModel
        return viewController
    }

    private func closeMyRadioAudioPlayer() {
        tabBarController.closePopup(animated: true, completion: nil)
    }
}

extension RadioPlayerCoordinator: RadioPlayerViewModelDelegate {
    func closeAudioPlayer() {
        closeMyRadioAudioPlayer()
    }
}
