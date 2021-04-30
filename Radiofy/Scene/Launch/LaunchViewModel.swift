//
//  LaunchViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 27/04/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import Foundation

final class LaunchViewModel: LaunchModule.ViewModel {

    weak var delegate: LaunchModule.CoordinatorDelegate?

    private let service: LaunchModule.Service

    init(service: LaunchModule.Service) {
        self.service = service
    }

    func isUserLoggedIn() {
        let result = service.isUserLoggedIn
        switch result {
        case true:
            delegate?.showHomeTabBar()
        case false:
            delegate?.showOnboardingPath()
        }
    }

    func setupEmailLanguage() {
        service.setFirebaseEmailLanguage()
    }

}
