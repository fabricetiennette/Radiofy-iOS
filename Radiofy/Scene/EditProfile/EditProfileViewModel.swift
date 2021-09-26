//
//  EditProfileViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 04/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation

class EditProfileViewModel {

    var userHandler: ((_ name: String, _ photoURL: String) -> Void)?
    var errorHandler: ((_ message: String) -> Void)?
    var successHandler: (() -> Void)?

    // MARK: - Injection

    private let authService: AuthService
    private let firestoreService: FirestoreService
    private let storageService: StorageService

    // MARK: - Init

    init(
        authService: AuthService = .init(),
        firestoreService: FirestoreService = .init(),
        storageService: StorageService = .init()
    ) {
        self.authService = authService
        self.firestoreService = firestoreService
        self.storageService = storageService
    }

    // MARK: - viewModel Method

    func getUserInfoToEdit() {
        getUserInfoFromDatabase()
    }

    func saveUserInfo(_ imageData: Data?, _ userName: String) {
        guard let email = authService.userEmail else { return }
        guard let data = imageData else {
            errorHandler?(L10n.photoInvalidTryAgain)
            return
        }

        guard userName != "" && userName.count > 1 && userName.count <= 15 else {
            errorHandler?(L10n.nameInvalid)
            return
        }

        storageService.saveUserImageToDatabase(email: email, data: data) { result in
            switch result {
            case .success(let url):
                self.mergeNewUserInfo(email: email, url: url, userName: userName)
            case .failure(let error):
                self.errorHandler?(error.localizedDescription)
            }
        }
    }

    // MARK: - Private

    private func getUserInfoFromDatabase() {
        guard let email = authService.userEmail else { return }
        firestoreService.getUserInfoFromDatabase(email: email) { result in
            switch result {
            case .success((let name, let photoURL)):
                self.userHandler?(name, photoURL)
            case .failure:
                self.errorHandler?(L10n.AnErrorHadOccurred.tryLater)
            }
        }
    }

    private func mergeNewUserInfo(email: String, url: URL, userName: String) {
        firestoreService.mergeNewInfoToUserDatabase(email: email, url: url, userName: userName) { result in
            switch result {
            case .success:
                self.successHandler?()
            case .failure(let error):
                self.errorHandler?(error.localizedDescription)
            }
        }
    }
}
