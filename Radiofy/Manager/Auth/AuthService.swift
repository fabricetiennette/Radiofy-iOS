//
//  AuthService.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 24/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation

public class AuthService {

    private var authManager: AuthProtocol

    init(authManager: AuthProtocol = AuthManager()) {
        self.authManager = authManager
    }

    // CurrentUser
    var currentUser: UserProtocol? {
        return authManager.currentUser
    }

    var isAnonymous: Bool {
        return authManager.isAnonymous
    }

    // User email
    var userEmail: String? {
        return authManager.userEmail
    }

    // Sign In user from Firebase
    func signIn(
        email: String,
        password: String,
        callback: @escaping (AuthResult) -> Void
    ) {
        authManager.signIn(email: email, password: password) { result in
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
        authManager.linkUserToAnonymous(email: email, password: password) { result in
            switch result {
            case .success(let auth):
                callback(.success(auth))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }

    func signInAnonymously(callback: @escaping (AuthResult) -> Void) {
        authManager.signInUserAnonymously { result in
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
        authManager.signOutUser { result in
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
        return authManager.isUserEmailVerified()
    }

    // create and save user in firebase
    func createUser(
        name: String,
        password: String,
        email: String,
        callback: @escaping (AuthResult) -> Void
    ) {
        authManager.createUser(name: name, password: password, email: email) { result in
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
        authManager.sendEmailVerificationToUser { result in
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
        authManager.sendPasswordReset(email: email) { result in
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
        authManager.stateDidChangeForAuth {
            callback()
        }
    }

    // Remove authentication Listener
    func removeListener() {
        authManager.removeListener()
    }

    // reauthenticate user
    func reauthenticate(
        password: String?,
        callback: @escaping (AuthResult) -> Void
    ) {
        authManager.reauthenticate(password: password) { result in
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
        authManager.deleteUserAuthentication(with: email) { result in
            switch result {
            case .success(let success):
                callback(.success(success))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
}
