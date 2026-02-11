//
//  AccountViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 20/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
import SDWebImage
import FRadioPlayer

protocol AccountViewModelDelete: AnyObject {
    func showSubscriptionPage()
}

class AccountViewModel {

    private weak var delegate: AccountViewModelDelete?

    var userHandler: ((_ name: String, _ email: String) -> Void)?
    var deleteActionHandler: ((_ alert: UIAlertAction) -> Void)?
    var errorHandler: ((_ title: String, _ message: String) -> Void)?
    var successHandler: (() -> Void)?
    var userIsNotAnonymous: (() -> Void)?

    private let player = FRadioPlayer.shared

    // MARK: - Injection

    private var legacyFirebaseAuthService: LegacyFirebaseAuthService
    private let firestoreService: FirestoreService
    private let storageService: StorageService

    // MARK: - Init

    init(
        legacyFirebaseAuthService: LegacyFirebaseAuthService = .init(),
        firestoreService: FirestoreService = .init(),
        storageService: StorageService = .init(),
        delegate: AccountViewModelDelete?
    ) {
        self.legacyFirebaseAuthService = legacyFirebaseAuthService
        self.firestoreService = firestoreService
        self.storageService = storageService
        self.delegate = delegate
    }

    // MARK: - viewModel Methods

    func isUserLoggedIn() {
        legacyFirebaseAuthService.stateDidChangeForAuth {
            RadioPlayerViewController.player?.pause()
            self.player.stop()
            self.showStartViewIfSignOut()
        }
    }

    func isUserAnonymous() {
        if legacyFirebaseAuthService.isAnonymous == false {
            self.userIsNotAnonymous?()
        }
    }

    func getUserNameAndEmail() {
        guard let email = legacyFirebaseAuthService.userEmail else { return }
        firestoreService
            .getDocument(collection: "users", document: email, get: "name") { result in
            switch result {
            case .success(let name):
                self.userHandler?(name, email)
            case .failure:
                self.errorHandler?(L10n.error, L10n.couldNotGetInfoTryLater)
            }
        }
    }

    func reauthenticateAndDelete(with password: String?) {
        legacyFirebaseAuthService.reauthenticate(password: password) { [weak self] result in
            guard let me = self else { return }
            switch result {
            case .success:
                me.deleteUserAccount()
            case .failure(let error):
                me.errorHandler?(L10n.error, error.localizedDescription)
            }
        }
    }

    func openSubscriptionPage() {
        delegate?.showSubscriptionPage()
    }

    // MARK: - Private

    private func deleteUserAccount() {
        guard let email = legacyFirebaseAuthService.userEmail else { return }
        deleteUserImageInStorage(with: email)
    }

    private func deleteUserImageInStorage(with email: String) {
        storageService.deleteUserImage(with: email) { result in
            switch result {
            case .failure(let error):
                self.errorHandler?(L10n.error, error.localizedDescription)
            case .success:
                self.deleteUserInDatabase(with: email)
            }
        }
    }

    private func deleteUserInDatabase(with email: String) {
        firestoreService.deleteUserInDatabase(with: email) { result in
            switch result {
            case .failure(let error):
                self.errorHandler?(L10n.error, error.localizedDescription)
            case .success:
                self.deleteUserAuthentication(with: email)
            }
        }
    }

    private func deleteUserAuthentication(with email: String) {
        legacyFirebaseAuthService.deleteUserAuthentication(with: email) { result in
            switch result {
            case .success:
                self.resetDefaults()
                self.clearCache()
            case .failure(let error):
                self.errorHandler?(L10n.error, error.localizedDescription)
            }
        }
    }

    // Delete UserDefaults objects
    private func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }

    // Clear Cache
    private func clearCache() {
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
    }

    private func showStartViewIfSignOut() {
//        NotificationCenter.default.post( name: SettingsViewModel.NotificationDone, object: nil)
    }
}
