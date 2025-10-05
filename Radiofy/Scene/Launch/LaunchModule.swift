//
//  LaunchModule.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 27/04/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import UIKit
import SwiftUI

protocol LaunchOutputBinding: ObservableObject {
    var isOn: Bool { get }
    
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

final class LaunchModule {

    typealias ViewModel = LaunchOutputBinding
    typealias Service = LaunchServiceProtocol
    typealias CoordinatorDelegate = LaunchViewModelDelegate

    private weak var coordinatorDelegate: CoordinatorDelegate?
    private let needAnimation: Bool

    var launchView: some View {
        let service = LaunchService()
        let viewModel = LaunchViewModel(service: service, needAnimation: needAnimation)
        viewModel.delegate = coordinatorDelegate
        return LaunchView(viewModel: viewModel)
    }

    init(coordinatorDelegate: CoordinatorDelegate?, needAnimation: Bool) {
        self.coordinatorDelegate = coordinatorDelegate
        self.needAnimation = needAnimation
    }
}
