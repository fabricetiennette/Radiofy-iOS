//
//  StartViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 27/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol StartViewModelDelegate: class {
    func signUp()
    func logIn()
    func signIn()
}

class StartViewModel {

    private weak var delegate: StartViewModelDelegate?

    // MARK: - Closure

    var errorHandler: ((_ title: String, _ message: String) -> Void)?

    // MARK: - Injection

    private let authService: AuthService

    init(
        delegate: StartViewModelDelegate?,
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
