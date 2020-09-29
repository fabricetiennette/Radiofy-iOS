//
//  SettingViewModelTests.swift
//  RadiofyTests
//
//  Created by Fabrice Etiennette on 26/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
@testable import Radiofy

class SettingViewModelTests: XCTestCase {

    let fakeName = "tester"
    let fakeEmail = "tests@radiofy.com"
    var fakeAuthDataResult = FakeAuthDataResult(user: FakeUser(displayName: "", email: ""))

    override func setUp() {
           fakeAuthDataResult.user?.displayName = fakeName
           fakeAuthDataResult.user?.email = fakeEmail
    }

    func testSignOutUserWithFailure() {
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
        let mockAuthService = MockAuthService(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authManager: mockAuthService)
        let settingViewModel = SettingsViewModel(delegate: self as? SettingsViewModelDelegate, authService: authService, firestoreService: firestoreService)
        let expect = expectation(description: "Email error expected :D")

        // When:
        settingViewModel.errorHandler = { title, message in
            XCTAssertEqual(title, "Error")
            expect.fulfill()
        }
        settingViewModel.signOutUser()

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testUsernameWithFailure() {
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
        let mockAuthService = MockAuthService(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authManager: mockAuthService)
        let settingViewModel = SettingsViewModel(delegate: self as? SettingsViewModelDelegate, authService: authService, firestoreService: firestoreService)
        let expect = expectation(description: "Email error expected :D")

        // When:
        settingViewModel.errorHandler = { title, message in
            XCTAssertEqual(title, "Error")
            expect.fulfill()
        }
        settingViewModel.getUserName()

        // Then:
        wait(for: [expect], timeout: 3)
    }
}
