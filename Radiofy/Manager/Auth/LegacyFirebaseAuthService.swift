//
//  AuthService.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 24/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation

public class LegacyFirebaseAuthService {

    private var legacyFirebaseAuthManager: LegacyFirebaseAuthProtocol

    init(legacyFirebaseAuthManager: LegacyFirebaseAuthProtocol = LegacyFirebaseAuthManager()) {
        self.legacyFirebaseAuthManager = legacyFirebaseAuthManager
    }

    // CurrentUser
    var currentUser: UserProtocol? {
        return legacyFirebaseAuthManager.currentUser
    }

    var isAnonymous: Bool {
        return legacyFirebaseAuthManager.isAnonymous
    }

    // User email
    var userEmail: String? {
        return legacyFirebaseAuthManager.userEmail
    }

    // Sign In user from Firebase
    func signIn(
        email: String,
        password: String,
        callback: @escaping (AuthResult) -> Void
    ) {
        legacyFirebaseAuthManager.signIn(email: email, password: password) { result in
            switch result {
            case .success(let auth):
                callback(.success(auth))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }

    func linkUserToAnonymous(
        email: String,
        password: String,
        callback: @escaping (AuthResult) -> Void
    ) {
        legacyFirebaseAuthManager.linkUserToAnonymous(email: email, password: password) { result in
            switch result {
            case .success(let auth):
                callback(.success(auth))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }

    func signInAnonymously(callback: @escaping (AuthResult) -> Void) {
        legacyFirebaseAuthManager.signInUserAnonymously { result in
            switch result {
            case .success(let auth):
                callback(.success(auth))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }

    // Sign Out user
    func signOutUser(callback: @escaping (Result<Any, Error>) -> Void) {
        legacyFirebaseAuthManager.signOutUser { result in
            switch result {
            case .success:
                callback(.success(()))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }

    // check if user email if verified
    func isUserEmailVerified() -> Bool {
        return legacyFirebaseAuthManager.isUserEmailVerified()
    }

    // create and save user in firebase
    func createUser(
        name: String,
        password: String,
        email: String,
        callback: @escaping (AuthResult) -> Void
    ) {
        legacyFirebaseAuthManager.createUser(name: name, password: password, email: email) { result in
            switch result {
            case .success(let auth):
                callback(.success(auth))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }

    // send a verification email to the user
    func sendEmailVerificationToUser(
        callback: @escaping (Result<Any, Error>) -> Void
    ) {
        legacyFirebaseAuthManager.sendEmailVerificationToUser { result in
            switch result {
            case .success(let success):
                callback(.success(success))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }

    // send an email to user and reset his password
    func sendPasswordReset(
        email: String,
        callback: @escaping (Result<Void, Error>) -> Void
    ) {
        legacyFirebaseAuthManager.sendPasswordReset(email: email) { result in
            switch result {
            case .success(let success):
                callback(.success(success))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }

    // Add authentication Listener
    func stateDidChangeForAuth(callback: @escaping () -> Void) {
        legacyFirebaseAuthManager.stateDidChangeForAuth {
            callback()
        }
    }

    // Remove authentication Listener
    func removeListener() {
        legacyFirebaseAuthManager.removeListener()
    }

    // reauthenticate user
    func reauthenticate(
        password: String?,
        callback: @escaping (AuthResult) -> Void
    ) {
        legacyFirebaseAuthManager.reauthenticate(password: password) { result in
            switch result {
            case .success(let auth):
                callback(.success(auth))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }

    // Delete user authentication
    func deleteUserAuthentication(
        with email: String,
        callback: @escaping (Result<Void, Error>) -> Void
    ) {
        legacyFirebaseAuthManager.deleteUserAuthentication(with: email) { result in
            switch result {
            case .success(let success):
                callback(.success(success))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
}
