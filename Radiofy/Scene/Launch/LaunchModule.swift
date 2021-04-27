//
//  LaunchModule.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 27/04/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import UIKit

struct LaunchModule {

    typealias ViewModel = LaunchOutputBinding
    typealias Service = LaunchServiceProtocol
    typealias CoordinatorDelegate = LaunchViewModelDelegate

    // swiftlint:disable:next weak_delegate
    private let coordinatorDelegate: CoordinatorDelegate

    init(coordinatorDelegate: CoordinatorDelegate) {
        self.coordinatorDelegate = coordinatorDelegate
    }

    var viewController: UIViewController {
        let service = LaunchService()
        let viewModel = LaunchViewModel(service: service)
        let launchViewController = LaunchViewController(viewModel: viewModel)
        viewModel.delegate = coordinatorDelegate
        return launchViewController
    }
}

protocol LaunchOutputBinding {
    func isUserLoggedIn()
    func setupEmailLanguage()
}

protocol LaunchServiceProtocol {
    var isUserLoggedIn: Bool { get }
    func setFirebaseEmailLanguage()
}

protocol LaunchViewModelDelegate: AnyObject {
    func showOnboardingPath()
    func showHomeTabBar()
}
