//
//  PasswordResetModule.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 29/05/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import UIKit
import Combine

final class PasswordResetModule {

    typealias ViewModel = PasswordResetInputBinding & PasswordResetOutputBinding
    typealias Service = PasswordResetServiceProtocol

    var viewController: UIViewController {
        let service = PasswordResetService()
        let viewModel = PasswordResetViewModel(service: service)
        let loginViewController = PasswordResetViewController.instantiate(from: .start)
        loginViewController.viewModel = viewModel
        return loginViewController
    }
}

protocol PasswordResetInputBinding {
    func resetPassword(with emailText: String?)
}

protocol PasswordResetOutputBinding {
    var errorPublisher: PassthroughSubject<String, Never> { get set }
    var emailSuccessPublisher: PassthroughSubject<String, Never> { get set }
}

protocol PasswordResetServiceProtocol {
    func sendPasswordReset(email: String) -> AnyPublisher<Void, Error>
}
