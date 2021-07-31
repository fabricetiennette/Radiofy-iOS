//
//  SettingsViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 01/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
import Firebase
import FRadioPlayer
import Combine

class SettingsViewModel: SettingsModule.ViewModel {

    // MARK: - Delegate

    weak var delegate: SettingsModule.CoordinatorDelegate?

    @Published var signOut: Void?

    static let NotificationDone = NSNotification.Name(rawValue: "Done")

    private let player = FRadioPlayer.shared
    private var disposedBag = Set<AnyCancellable>()

    var errorSubject = PassthroughSubject<(String, String), Never>()
    var userNameSubject = PassthroughSubject<String, Never>()
    var refSubject = PassthroughSubject<StorageReference, Never>()
    var userIsNotAnonymousSubject = PassthroughSubject<Void, Never>()

    // MARK: - Injection

    private let service: SettingsModule.Service

    // MARK: - Init

    init(service: SettingsModule.Service) {
        self.service = service
    }

    func isUserLoggedIn() {
        service
            .stateDidChangeForAuth()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                RadioPlayerViewController.player?.pause()
                self.player.stop()
                self.showStartViewIfSignOut()
            }
            .store(in: &disposedBag)
    }

    private func showStartViewIfSignOut() {
//        NotificationCenter.default.post(name: SettingsViewModel.NotificationDone, object: nil)
        $signOut
            .sink { _ in }
            .store(in: &disposedBag)
    }

    func removeListener() {
        service.removeListener()
    }

    func isUserAnonymous() {
        if service.isAnonymous == false {
            userIsNotAnonymousSubject.send()
        }
    }

    func signOutUser() {
        ifAnonymousDeleteUser()
        service
            .signOutUser()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .finished: break
                case .failure(let error):
                    self.errorSubject.send((L1s.error, error.localizedDescription))
                }
            } receiveValue: { _ in }
            .store(in: &disposedBag)
    }

    func showOrCreateProfileView() {
        if service.isAnonymous {
            delegate?.createAccount()
        } else {
            delegate?.editProfile()
        }
    }

    func showAccountView() {
        delegate?.accountPage()
    }

    func showAboutView() {
        delegate?.aboutPage()
    }

    func getUserName() {
        guard let email = service.userEmail else { return }
        service
            .getUserName(email: email)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .finished: break
                case .failure(let error):
                    self.errorSubject.send((L1s.error, error.localizedDescription))
                }
            } receiveValue: { [weak self] name in
                guard let self = self else { return }
                self.userNameSubject.send(name)
            }
            .store(in: &disposedBag)
    }

    func getUserProfilePhotoReference() {
        guard let email = service.userEmail else { return }
        service
            .userStorageReference(email: email)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] reference in
                guard let self = self else { return }
                self.refSubject.send(reference)
            }
            .store(in: &disposedBag)
    }

    func ifAnonymousDeleteUser() {
        guard let user = service.currentUser else { return }
        if service.isAnonymous { user.delete() }
    }
}
