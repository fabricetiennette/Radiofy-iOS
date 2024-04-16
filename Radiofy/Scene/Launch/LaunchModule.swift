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

    private weak var coordinatorDelegate: CoordinatorDelegate?
    private let needAnimation: Bool

    init(coordinatorDelegate: CoordinatorDelegate?, needAnimation: Bool) {
        self.coordinatorDelegate = coordinatorDelegate
        self.needAnimation = needAnimation
    }

    var viewController: UIViewController {
        let service = LaunchService()
        let viewModel = LaunchViewModel(service: service, needAnimation: needAnimation)
        let launchViewController = LaunchViewController(viewModel: viewModel)
        viewModel.delegate = coordinatorDelegate
        return launchViewController
    }
}

protocol LaunchOutputBinding {
    func isUserLoggedIn()
    func setupEmailLanguage()
    var isOn: Bool { get }
}

protocol LaunchServiceProtocol {
    var isUserLoggedIn: Bool { get }
    func setFirebaseEmailLanguage()
}

protocol LaunchViewModelDelegate: AnyObject {
    func showOnboardingPath()
    func showHomeTabBar()
}
