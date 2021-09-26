//
//  PasswordResetViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 29/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
import Combine

final class PasswordResetViewModel: PasswordResetModule.ViewModel {

    private let service: PasswordResetModule.Service

    var errorSubject = PassthroughSubject<String, Never>()
    var emailSuccessSubject = PassthroughSubject<String, Never>()
    private var disposeBag = Set<AnyCancellable>()

    init(service: PasswordResetModule.Service) {
        self.service = service
    }

    func resetPassword(with emailText: String?) {
        if validateTextFields(emailText) == nil {

            let email = emailText.clearedText()

            sendPasswordReset(with: email)
        }
    }

    private func sendPasswordReset(with email: String) {
        service.sendPasswordReset(email: email)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.errorSubject.send(error.localizedDescription)
                case .finished: break
                }
            } receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.emailSuccessSubject.send("\(L10n.anEmailWasSentTo) \(email).")
            }
            .store(in: &disposeBag)
    }

    // validate emailTextFields text is correct
    private func validateTextFields(_ emailTextField: String?) -> Void? {

        // validate email is in a good format
        let email = emailTextField.clearedText()
        if email.isValidEmail() == false {
            return errorSubject.send(L10n.emailInvalid)
        }

        return nil
    }
}
