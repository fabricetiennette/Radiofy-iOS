//
//  OnBoardingViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 27/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol OnBoardingViewModelDelegate: class {
    func signUp()
    func logIn()
    func signIn()
}

class OnBoardingViewModel {

    private weak var delegate: OnBoardingViewModelDelegate?

    // MARK: - Closure

    var errorHandler: ((_ title: String, _ message: String) -> Void)?

    // MARK: - Injection

    private let authService: AuthService

    init(
        delegate: OnBoardingViewModelDelegate?,
        authService: AuthService = .init()
    ) {
        self.delegate = delegate
        self.authService = authService
    }

    func openSignUpView() {
        delegate?.signUp()
    }

    func openLogInView() {
        delegate?.logIn()
    }

    func signInAnonymously() {
        authService.signInAnonymously { [weak self] result in
            guard let me = self else { return }
            switch result {
            case .success:
                me.delegate?.signIn()
            case .failure(let error):
                me.errorHandler?(L1s.error, error.localizedDescription)
            }
        }
    }
}
