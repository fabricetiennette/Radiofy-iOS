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

protocol SettingsViewModelDelegate: AnyObject {
    func callEditProfile()
    func callAccountPage()
    func callAboutPage()
    func createAccount()
}

class SettingsViewModel {

    @Published var signOut: Void?
    private var cancelSet: Set<AnyCancellable> = []

    static let NotificationDone = NSNotification.Name(rawValue: "Done")

    private weak var delegate: SettingsViewModelDelegate?
    private let player = FRadioPlayer.shared

    var errorHandler: ((_ title: String, _ message: String) -> Void)?
    var userNameHandler: ((_ userName: String) -> Void)?
    var refHandler: ((_ ref: StorageReference) -> Void)?
    var userIsNotAnonymous: (() -> Void)?

    // MARK: - Injection

    private var authService: AuthService
    private let firestoreService: FirestoreService
    private let storageService: StorageService

    // MARK: - Init

    init(
        delegate: SettingsViewModelDelegate?,
        authService: AuthService = .init(),
        firestoreService: FirestoreService = .init(),
        storageService: StorageService = .init()
    ) {
        self.delegate = delegate
        self.authService = authService
        self.firestoreService = firestoreService
        self.storageService = storageService
    }

    func isUserLoggedIn() {
        authService.stateDidChangeForAuth {
            RadioPlayerViewController.player?.pause()
            self.player.stop()
            self.showStartViewIfSignOut()
        }
    }

    private func showStartViewIfSignOut() {
//        NotificationCenter.default.post(
//            name: SettingsViewModel.NotificationDone, object: nil)
        self.$signOut.sink { _ in }.store(in: &cancelSet)
    }

    func removeListener() {
        authService.removeListener()
    }

    func isUserAnonymous() {
        if authService.isAnonymous == false {
            self.userIsNotAnonymous?()
        }
    }

    func signOutUser() {
        ifAnonymousDeleteUser()
        authService.signOutUser { [weak self] result in
            guard let me = self else { return }
            switch result {
            case .success: break
            case .failure(let error):
                me.errorHandler?(L1s.error, error.localizedDescription)
            }
        }
    }

    func showOrCreateProfileView() {
        if authService.isAnonymous {
            delegate?.createAccount()
        } else {
            delegate?.callEditProfile()
        }
    }

    func showAccountView() {
        delegate?.callAccountPage()
    }

    func showAboutView() {
        delegate?.callAboutPage()
    }

    func getUserName() {
        guard let email = authService.userEmail else { return }
        firestoreService.getUserName(email: email) { result in
            switch result {
            case .success(let name):
                self.userNameHandler?(name)
            case .failure(let error):
                self.errorHandler?(L1s.error, error.localizedDescription)
            }
        }
    }

    func getUserProfilePhotoReference() {
        guard let email = authService.userEmail else { return }
        let ref = storageService.userStorageReference(email: email)
        refHandler?(ref)
    }

    func ifAnonymousDeleteUser() {
        guard let user = Auth.auth().currentUser else { return}
        if authService.isAnonymous {
            user.delete()
        }
    }
}
