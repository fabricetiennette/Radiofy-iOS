//
//  AuthManager.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 22/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import FirebaseAuth

class AuthManager: AuthProtocol {

    let firebaseAuth = Auth.auth()
    var handle: AuthStateDidChangeListenerHandle = Auth.auth()

    var currentUser: UserProtocol? {
        return firebaseAuth.currentUser
    }

    var userEmail: String? {
        return firebaseAuth.currentUser?.email
    }

    var isAnonymous: Bool {
        let user = firebaseAuth.currentUser
        if user?.isAnonymous == true {
            return true
        } else {
            return false
        }
    }

    // Sign In user from Firebase
    func signIn(
        email: String,
        password: String,
        callback: @escaping (AuthResult) -> Void
    ) {
        firebaseAuth.signIn(withEmail: email, password: password) { (auth, error) in
            if let error = error {
                callback(.failure(error))
                return
            }
            if let user = auth?.user {
                callback(.success(user))
                return
            }
        }
    }

    func linkUserToAnonymous(
        email: String,
        password: String,
        callback: @escaping (AuthResult) -> Void
    ) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        firebaseAuth.currentUser?.link(with: credential, completion: { auth, error in
            if let error = error {
                callback(.failure(error))
                return
            }
            if let user = auth?.user {
                callback(.success(user))
                return
            }
        })
    }

    // Sign Out user
    func signOutUser(callback: @escaping (Result<Any, Error>) -> Void) {
        do {
            try firebaseAuth.signOut()
            callback(.success("success"))
        } catch let signOutError {
            callback(.failure(signOutError))
        }
    }

    // check if user email if verified
    func isUserEmailVerified() -> Bool {
        guard let user = firebaseAuth.currentUser else { return false }
        return user.isEmailVerified
    }

    // create and save user in firebase
    func createUser(
        name: String,
        password: String,
        email: String,
        callback: @escaping (AuthResult) -> Void
    ) {
        firebaseAuth.createUser(withEmail: email, password: password) { auth, error in
            if let error = error {
                callback(.failure(error))
                return
            }
            if let user = auth?.user {
                callback(.success(user))
                return
            }
        }
    }

    // send a verification email to the user
    func sendEmailVerificationToUser(
        callback: @escaping (Result<Any, Error>) -> Void
    ) {
        firebaseAuth.currentUser?.sendEmailVerification(completion: { (error) in
            if let error = error {
                callback(.failure(error))
            }
            callback(.success("success"))
        })
    }

    // send an email to user and reset his password
    func sendPasswordReset(
        email: String,
        callback: @escaping (Result<Void, Error>) -> Void
    ) {
        firebaseAuth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                callback(.failure(error))
            } else {
                callback(.success(()))
            }
        }
    }

    // Add authentication Listener
    func stateDidChangeForAuth(callback: @escaping () -> Void) {
        handle = firebaseAuth.addStateDidChangeListener { _, user in
            if user == nil {
                callback()
            }
        }
    }

    func removeListener() {
        firebaseAuth.removeStateDidChangeListener(handle)
    }

    // reauthenticate user
    func reauthenticate(
        password: String?,
        callback: @escaping (AuthResult) -> Void
    ) {
        var credential: AuthCredential
        guard
            let user = self.firebaseAuth.currentUser,
            let email = firebaseAuth.currentUser?.email,
            let myPassword = password
            else { return }
        credential = EmailAuthProvider.credential(withEmail: email, password: myPassword)
        user.reauthenticate(with: credential) { auth, error in
            if let error = error {
                callback(.failure(error))
            } else {
                guard let user = auth?.user else { return }
                callback(.success(user))
            }
        }
    }

    // Delete user authentication
    func deleteUserAuthentication(
        with email: String,
        callback: @escaping (Result<Void, Error>) -> Void
    ) {
        let user = firebaseAuth.currentUser
        user?.delete(completion: { error in
            if let error = error {
                callback(.failure(error))
                return
            } else {
                callback(.success(()))
            }
        })
    }

    func signInUserAnonymously(callback: @escaping (AuthResult) -> Void) {
        firebaseAuth.signInAnonymously { (authResult, error) in
            if let error = error {
                callback(.failure(error))
            } else {
                guard let user = authResult?.user else { return }
                callback(.success(user))
            }
        }
    }
}

extension User: UserProtocol {}
