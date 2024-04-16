//
//  AuthProtocol.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 24/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation

typealias AuthResult = Result<UserProtocol, Error>

protocol AuthProtocol {
    var currentUser: UserProtocol? { get }
    var userEmail: String? { get }
    var isAnonymous: Bool { get }

    func reauthenticate(
        password: String?,
        callback: @escaping (AuthResult) -> Void
    )
    func deleteUserAuthentication(
        with email: String,
        callback: @escaping (Result<Void, Error>) -> Void
    )
    func signIn(
        email: String,
        password: String,
        callback: @escaping (AuthResult) -> Void
    )
    func signOutUser(callback: @escaping (Result<Any, Error>) -> Void)
    func isUserEmailVerified() -> Bool
    func createUser(
        name: String,
        password: String,
        email: String,
        callback: @escaping (AuthResult) -> Void
    )
    func sendEmailVerificationToUser(
        callback: @escaping (Result<Any, Error>) -> Void
    )
    func linkUserToAnonymous(
        email: String,
        password: String,
        callback: @escaping (AuthResult) -> Void
    )
    func sendPasswordReset(
        email: String,
        callback: @escaping (Result<Void, Error>) -> Void
    )
    func stateDidChangeForAuth(callback: @escaping () -> Void)
    func removeListener()
    func signInUserAnonymously(callback: @escaping (AuthResult) -> Void)
}
