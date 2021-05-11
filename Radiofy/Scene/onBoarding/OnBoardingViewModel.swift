//
//  OnBoardingViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 27/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
import Combine

final class OnBoardingViewModel: OnBoardingModule.ViewModel {

    var errorHandler: ((String, String) -> Void) = { _, _  in }

    weak var delegate: OnBoardingModule.CoordinatorDelegate?

    private let service: OnBoardingModule.Service

    init(service: OnBoardingModule.Service) {
        self.service = service
    }

    func openSignUpView() {
        delegate?.signUp()
    }

    func openLogInView() {
        delegate?.logIn()
    }

    func signInAnonymously() {
        service.signInAnonymously { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.delegate?.signIn()
            case .failure(let error):
                self.errorHandler(L1s.error, error.localizedDescription)
            }
        }
    }
}
