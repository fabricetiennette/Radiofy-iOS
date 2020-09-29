//
//  AccountViewModelTests.swift
//  RadiofyTests
//
//  Created by Fabrice Etiennette on 26/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
@testable import Radiofy

class AccountViewModelTests: XCTestCase {

    let fakeName = "tester"
    let fakeEmail = "testing@radiofy.com"
    var fakeAuthDataResult = FakeAuthDataResult(user: FakeUser(displayName: "", email: ""))

    override func setUp() {
           fakeAuthDataResult.user?.displayName = fakeName
           fakeAuthDataResult.user?.email = fakeEmail
    }

    func testCheckStateAndSignOutWithSuccess() {
        // Given:
        let fakeAuthResponse = FakeAuthResponse(
            authDataResult: fakeAuthDataResult,
            error: nil
        )
        let fakeFirestoreResponse = FakeFirestoreResponse(
            querySnapshot: nil, error: nil
        )
        let mockFirestoreService = MockFirestoreService(
            fakeFirestoreResponse: fakeFirestoreResponse
        )
        let firestoreService = FirestoreService(
            firestoreManager: mockFirestoreService
        )
        let fakeStorageResponse = FakeStorageResponse(ref: nil, error: FakeNetworkResponse.networkError)
        let mockStorageService = MockStorageService(fakeStorageResponse: fakeStorageResponse)
        let storageService = StorageService(storageManager: mockStorageService)
        let mockAuthService = MockAuthService(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authManager: mockAuthService)
        let accountViewModel = AccountViewModel(authService: authService, firestoreService: firestoreService, storageService: storageService)
        let expect = expectation(description: "Email error expected :D")

        // When:
        accountViewModel.isUserLoggedIn()
        expect.fulfill()

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testGetUsernameAndEmailWithFailure() {
        // Given:
        let fakeAuthResponse = FakeAuthResponse(
            authDataResult: fakeAuthDataResult,
            error: nil
        )
        let fakeFirestoreResponse = FakeFirestoreResponse(
            querySnapshot: nil, error: FakeNetworkResponse.networkError
        )
        let mockFirestoreService = MockFirestoreService(
            fakeFirestoreResponse: fakeFirestoreResponse
        )
        let firestoreService = FirestoreService(
            firestoreManager: mockFirestoreService
        )
        let fakeStorageResponse = FakeStorageResponse(ref: nil, error: FakeNetworkResponse.networkError)
        let mockStorageService = MockStorageService(fakeStorageResponse: fakeStorageResponse)
        let storageService = StorageService(storageManager: mockStorageService)
        let mockAuthService = MockAuthService(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authManager: mockAuthService)
        let accountViewModel = AccountViewModel(authService: authService, firestoreService: firestoreService, storageService: storageService)
        let expect = expectation(description: "Email error expected :D")

        // When:
        accountViewModel.errorHandler = { title, message in
            XCTAssertEqual(title, "Error")
            XCTAssertEqual(message, "Could not get info, try later.")
            expect.fulfill()
        }
        accountViewModel.getUserNameAndEmail()

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testReauthenticateAndDeleteWithSuccess() {
        // Given:
        let fakeAuthResponse = FakeAuthResponse(
            authDataResult: fakeAuthDataResult,
            error: nil
        )
        let fakeFirestoreResponse = FakeFirestoreResponse(
            querySnapshot: nil, error: nil
        )
        let mockFirestoreService = MockFirestoreService(
            fakeFirestoreResponse: fakeFirestoreResponse
        )
        let firestoreService = FirestoreService(
            firestoreManager: mockFirestoreService
        )
        let fakeStorageResponse = FakeStorageResponse(ref: nil, error: nil)
        let mockStorageService = MockStorageService(fakeStorageResponse: fakeStorageResponse)
        let storageService = StorageService(storageManager: mockStorageService)
        let mockAuthService = MockAuthService(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authManager: mockAuthService)
        let accountViewModel = AccountViewModel(authService: authService, firestoreService: firestoreService, storageService: storageService)
        let expect = expectation(description: "Email error expected :D")

        // When:
        accountViewModel.errorHandler = { title, message in
            XCTFail(title)
            XCTFail(message)
        }
        accountViewModel.reauthenticateAndDelete(with: "FakePassWord")
        expect.fulfill()

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testReauthenticateAndDeleteWithAuthFailure() {
        // Given:
        let fakeAuthResponse = FakeAuthResponse(
            authDataResult: nil,
            error: FakeNetworkResponse.networkError
        )
        let fakeFirestoreResponse = FakeFirestoreResponse(
            querySnapshot: nil, error: nil
        )
        let mockFirestoreService = MockFirestoreService(
            fakeFirestoreResponse: fakeFirestoreResponse
        )
        let firestoreService = FirestoreService(
            firestoreManager: mockFirestoreService
        )
        let fakeStorageResponse = FakeStorageResponse(ref: nil, error: nil)
        let mockStorageService = MockStorageService(fakeStorageResponse: fakeStorageResponse)
        let storageService = StorageService(storageManager: mockStorageService)
        let mockAuthService = MockAuthService(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authManager: mockAuthService)
        let accountViewModel = AccountViewModel(authService: authService, firestoreService: firestoreService, storageService: storageService)
        let expect = expectation(description: "Email error expected :D")

        // When:
        accountViewModel.errorHandler = { title, message in
            XCTAssertNotNil(title)
            XCTAssertNotNil(message)
            expect.fulfill()
        }
        accountViewModel.reauthenticateAndDelete(with: "FakePassWord")

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testReauthenticateAndDeleteWithFirestoreFailure() {
        // Given:
        let fakeAuthResponse = FakeAuthResponse(
            authDataResult: fakeAuthDataResult,
            error: nil
        )
        let fakeFirestoreResponse = FakeFirestoreResponse(
            querySnapshot: nil, error: FakeNetworkResponse.networkError
        )
        let mockFirestoreService = MockFirestoreService(
            fakeFirestoreResponse: fakeFirestoreResponse
        )
        let firestoreService = FirestoreService(
            firestoreManager: mockFirestoreService
        )
        let fakeStorageResponse = FakeStorageResponse(ref: nil, error: nil)
        let mockStorageService = MockStorageService(fakeStorageResponse: fakeStorageResponse)
        let storageService = StorageService(storageManager: mockStorageService)
        let mockAuthService = MockAuthService(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authManager: mockAuthService)
        let accountViewModel = AccountViewModel(authService: authService, firestoreService: firestoreService, storageService: storageService)
        let expect = expectation(description: "Email error expected :D")

        // When:
        accountViewModel.errorHandler = { title, message in
            XCTAssertNotNil(title)
            XCTAssertNotNil(message)
            expect.fulfill()
        }
        accountViewModel.reauthenticateAndDelete(with: "FakePassWord")

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testReauthenticateAndDeleteWithStorageFailure() {
        // Given:
        let fakeAuthResponse = FakeAuthResponse(
            authDataResult: fakeAuthDataResult,
            error: nil
        )
        let fakeFirestoreResponse = FakeFirestoreResponse(
            querySnapshot: nil, error: nil
        )
        let mockFirestoreService = MockFirestoreService(
            fakeFirestoreResponse: fakeFirestoreResponse
        )
        let firestoreService = FirestoreService(
            firestoreManager: mockFirestoreService
        )
        let fakeStorageResponse = FakeStorageResponse(ref: nil, error: FakeNetworkResponse.networkError)
        let mockStorageService = MockStorageService(fakeStorageResponse: fakeStorageResponse)
        let storageService = StorageService(storageManager: mockStorageService)
        let mockAuthService = MockAuthService(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authManager: mockAuthService)
        let accountViewModel = AccountViewModel(authService: authService, firestoreService: firestoreService, storageService: storageService)
        let expect = expectation(description: "Email error expected :D")

        // When:
        accountViewModel.errorHandler = { title, message in
            XCTAssertNotNil(title)
            XCTAssertNotNil(message)
            expect.fulfill()
        }
        accountViewModel.reauthenticateAndDelete(with: "FakePassWord")

        // Then:
        wait(for: [expect], timeout: 3)
    }
}
