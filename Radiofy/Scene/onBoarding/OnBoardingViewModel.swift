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

    var errorPublisher = PassthroughSubject<(String, String), Never>()

    weak var delegate: OnBoardingModule.CoordinatorDelegate?

    private var disposeBag = Set<AnyCancellable>()
    private let service: OnBoardingModule.Service

    init(service: OnBoardingModule.Service) {
        self.service = service
    }

    func didTapSignUp() {
        delegate?.goToSignUp()
    }

    func didTapLogIn() {
        delegate?.goToLogIn()
    }

    func didTapSignInAnonymously() {
        service
            .signInAnonymously()
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.errorPublisher.send((L1s.error, error.localizedDescription))
                case .finished: break
                }
            } receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.goToSignIn()
            }
            .store(in: &disposeBag)
    }
}
