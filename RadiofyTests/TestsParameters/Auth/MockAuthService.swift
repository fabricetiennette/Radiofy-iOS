//
//  MockAuthService.swift
//  RadiofyTests
//
//  Created by Fabrice Etiennette on 23/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
@testable import Radiofy

class MockAuthService: AuthProtocol {
    
    private(set) var isAnonymous: Bool
    private(set) var currentUser: UserProtocol?

    private let fakeAuthResponse: FakeAuthResponse

    init(fakeAuthResponse: FakeAuthResponse, isAnonymous: Bool = false) {
        self.fakeAuthResponse = fakeAuthResponse
        self.isAnonymous = isAnonymous
        self.currentUser = fakeAuthResponse.authDataResult?.user
    }

    var userEmail: String? {
        return "test@radiofy.io"
    }
    
    func linkUserToAnonymous(email: String, password: String, callback: @escaping (AuthResult) -> Void) {
        // Mock : si pas d’erreur, on "link" en transformant l’anonyme en user normal
        if let error = fakeAuthResponse.error {
            callback(.failure(error))
        } else if let user = fakeAuthResponse.authDataResult?.user {
            isAnonymous = false
            currentUser = user
            callback(.success(user))
        } else {
            callback(.failure(FakeNetworkResponse.networkError))
        }
    }
    
    func signInUserAnonymously(callback: @escaping (AuthResult) -> Void) {
        if let error = fakeAuthResponse.error {
            callback(.failure(error))
        } else if let user = fakeAuthResponse.authDataResult?.user {
            isAnonymous = true
            currentUser = user
            callback(.success(user))
        } else {
            callback(.failure(FakeNetworkResponse.networkError))
        }
    }

    func reauthenticate(password: String?, callback: @escaping (AuthResult) -> Void) {
        let authDataResult = fakeAuthResponse.authDataResult
        let error = fakeAuthResponse.error

        if let error = error {
            callback(.failure(error))
        }

        if let user = authDataResult?.user {
            callback(.success(user))
        }
    }

    func deleteUserAuthentication(with email: String, callback: @escaping (Result<Void, Error>) -> Void) {
        let error = fakeAuthResponse.error

        if let error = error {
            callback(.failure(error))
        } else {
            callback(.success(()))
        }
    }

    func signIn(email: String, password: String, callback: @escaping (AuthResult) -> Void) {
        let authDataResult = fakeAuthResponse.authDataResult
        let error = fakeAuthResponse.error

        if let error = error {
            callback(.failure(error))
        }

        if let user = authDataResult?.user {
            callback(.success(user))
        }
    }

    func signOutUser(callback: @escaping (Result<Any, Error>) -> Void) {
        let error = fakeAuthResponse.error

        if let error = error {
            callback(.failure(error))
        } else {
            callback(.success(()))
        }
    }

    // swiftlint:disable unused_optional_binding
    func isUserEmailVerified() -> Bool {
        let authDataResult = fakeAuthResponse.authDataResult

        if let _ = authDataResult?.user {
           return true
        } else {
            return false
        }
    }

    func createUser(name: String, password: String, email: String, callback: @escaping (AuthResult) -> Void) {
        let authDataResult = fakeAuthResponse.authDataResult
        let error = fakeAuthResponse.error

        if let error = error {
            callback(.failure(error))
        }

        if let user = authDataResult?.user {
            callback(.success(user))
        }
    }

    func sendEmailVerificationToUser(callback: @escaping (Result<Any, Error>) -> Void) {
        let error = fakeAuthResponse.error

        if let error = error {
            callback(.failure(error))
        } else {
            callback(.success(()))
        }
    }

    func sendPasswordReset(email: String, callback: @escaping (Result<Void, Error>) -> Void) {
        let error = fakeAuthResponse.error

        if let error = error {
            callback(.failure(error))
        } else {
            callback(.success(()))
        }
    }

    func stateDidChangeForAuth(callback: @escaping () -> Void) {
        callback()
    }

    func removeListener() {}
}

class EmailVerifiedMock: MockAuthService {
    override func sendEmailVerificationToUser(callback: @escaping (Result<Any, Error>) -> Void) {
        let error = FakeNetworkResponse.networkError
        callback(.failure(error))
    }
}

class EmailMock: MockAuthService {
    override func isUserEmailVerified() -> Bool {
        return false
    }
}
