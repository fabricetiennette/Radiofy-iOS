//
//  SignUpViewModelTests.swift
//  RadiofyTests
//
//  Created by Fabrice Etiennette on 20/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
@testable import Radiofy

class SignUpViewModelTests: XCTestCase {

    let fakeName = "tester"
    let fakeEmail = "tests@radiofy.com"
    var fakeAuthDataResult = FakeAuthDataResult(user: FakeUser(displayName: "", email: ""))

    override func setUp() {
        fakeAuthDataResult.user?.displayName = fakeName
        fakeAuthDataResult.user?.email = fakeEmail
    }

    func testEmailError_WhileCreatingUser() {
        // Given:
        let fakeAuthResponse = FakeAuthResponse(authDataResult: fakeAuthDataResult, error: nil)
        let mockAuthService = MockAuthService(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authManager: mockAuthService)
        let signUpViewModel = SignUpViewModel(delegate: self as? SignUpViewModelDelegate, authService: authService)
        let email = "slashteuf"
        let password = "Azerty12*"
        let name = "Tester"
        let expect = expectation(description: "Email error expected :D")

        // When:
        signUpViewModel.errorHandler = { message in
            XCTAssertEqual(message, "Email entered is not valid.")
            expect.fulfill()
        }
        signUpViewModel.signUpOneUser(name, email, password)

        // Then:
        wait(for: [expect], timeout: 10)
    }

    func testNameErrorIsTooShort_WhileCreatingUser() {
        // Given:
        let fakeAuthResponse = FakeAuthResponse(authDataResult: fakeAuthDataResult, error: nil)
        let mockAuthService = MockAuthService(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authManager: mockAuthService)
        let signUpViewModel = SignUpViewModel(delegate: self as? SignUpViewModelDelegate, authService: authService)
        let email = "slashteuf@hotmail.com"
        let password = "Azerty12*"
        let name = "T"
        let expect = expectation(description: "Email error expected :D")

        // When:
        signUpViewModel.errorHandler = { message in
            XCTAssertEqual(message, "Name entered is not valid. 2 character minimum & 15 Maximum.")
            expect.fulfill()
        }
        signUpViewModel.signUpOneUser(name, email, password)

        // Then:
        wait(for: [expect], timeout: 10)
    }

    func testNameErrorIsTooLongWhileCreatingUser() {
        // Given:
        let fakeAuthResponse = FakeAuthResponse(authDataResult: fakeAuthDataResult, error: nil)
        let mockAuthService = MockAuthService(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authManager: mockAuthService)
        let signUpViewModel = SignUpViewModel(delegate: self as? SignUpViewModelDelegate, authService: authService)
        let email = "slashteuf@hotmail.com"
        let password = "Azerty12*"
        let name = "1234567890123456"
        let expect = expectation(description: "Email error expected :D")

        // When:
        signUpViewModel.errorHandler = { message in
            XCTAssertEqual(message, "Name entered is not valid. 2 character minimum & 15 Maximum.")
            expect.fulfill()
        }
        signUpViewModel.signUpOneUser(name, email, password)

        // Then:
        wait(for: [expect], timeout: 10)
    }

    func testPasswordErrorWhileCreatingUser() {
        // Given:
        let signUpViewModel = SignUpViewModel(delegate: self as? SignUpViewModelDelegate)
        let email = "slashteuf@hotmail.com"
        let password = "Azerty12"
        let name = "Tester"
        let expect = expectation(description: "Email error expected :D")

        // When:
        signUpViewModel.errorHandler = { message in
            XCTAssertEqual(message, "Please make sure your password contain a least 8 characters, one special character and a number.")
            expect.fulfill()
        }
        signUpViewModel.signUpOneUser(name, email, password)

        // Then:
        wait(for: [expect], timeout: 10)
    }

    func testCreatUser_UserIsNotNil_ShouldNotFail() {
        let fakeAuthResponse = FakeAuthResponse(
            authDataResult: fakeAuthDataResult,
            error: nil
        )
        let fakeFirestoreResponse = FakeFirestoreResponse(
            querySnapshot: nil,
            error: nil
        )
        let mockAuthService = MockAuthService(fakeAuthResponse: fakeAuthResponse)
        let mockFirestoreService = MockFirestoreService(
            fakeFirestoreResponse: fakeFirestoreResponse
        )
        let firestoreService = FirestoreService(
            firestoreManager: mockFirestoreService
        )
        let authService = AuthService(authManager: mockAuthService)
        let signUpViewModel = SignUpViewModel(
            delegate: self as? SignUpViewModelDelegate,
            authService: authService,
            firestoreService: firestoreService
        )
        let password = "Azerty1*"
        let expect = expectation(description: "Wait for queue change.")

        signUpViewModel.errorHandler = {  message in
           XCTFail(message)
        }
        signUpViewModel.signUpOneUser(fakeName, fakeEmail, password)
        expect.fulfill()

        wait(for: [expect], timeout: 3)
    }

    func testCreatUser_UserIsNil_ShouldGetErrror() {
        let fakeAuthResponse = FakeAuthResponse(
            authDataResult: nil,
            error: FakeNetworkResponse.networkError
        )
        let fakeFirestoreResponse = FakeFirestoreResponse(
            querySnapshot: nil,
            error: nil
        )
        let mockFirestoreService = MockFirestoreService(
            fakeFirestoreResponse: fakeFirestoreResponse
        )
        let mockAuthService = MockAuthService(fakeAuthResponse: fakeAuthResponse)
        let firestoreService = FirestoreService(
            firestoreManager: mockFirestoreService
        )
        let authService = AuthService(authManager: mockAuthService)
        let signUpViewModel = SignUpViewModel(
            delegate: self as? SignUpViewModelDelegate,
            authService: authService,
            firestoreService: firestoreService
        )
        let password = "Azerty1*"
        let expect = expectation(description: "Wait for queue change.")

        signUpViewModel.errorHandler = {  message in
            XCTAssertNotNil(message)
            expect.fulfill()
        }
        signUpViewModel.signUpOneUser(fakeName, fakeEmail, password)

        wait(for: [expect], timeout: 3)
    }

    func testCreatUser_WithFirstoreError() {
        let fakeAuthResponse = FakeAuthResponse(
            authDataResult: fakeAuthDataResult,
            error: nil
        )
        let fakeFirestoreResponse = FakeFirestoreResponse(
            querySnapshot: nil,
            error: FakeNetworkResponse.networkError
        )
        let mockFirestoreService = MockFirestoreService(
            fakeFirestoreResponse: fakeFirestoreResponse
        )
        let mockAuthService = MockAuthService(fakeAuthResponse: fakeAuthResponse)
        let firestoreService = FirestoreService(
            firestoreManager: mockFirestoreService
        )
        let authService = AuthService(authManager: mockAuthService)
        let signUpViewModel = SignUpViewModel(
            delegate: self as? SignUpViewModelDelegate,
            authService: authService,
            firestoreService: firestoreService
        )
        let password = "Azerty1*"
        let expect = expectation(description: "Wait for queue change.")

        signUpViewModel.errorHandler = {  message in
            XCTAssertEqual(message, "Error saving user data")
            expect.fulfill()
        }
        signUpViewModel.signUpOneUser(fakeName, fakeEmail, password)

        wait(for: [expect], timeout: 3)
    }

    func testSendVerificationEmailWithError() {
        let fakeAuthResponse = FakeAuthResponse(
            authDataResult: fakeAuthDataResult,
            error: nil
        )
        let mockAuthService = EmailVerifiedMock(fakeAuthResponse: fakeAuthResponse)

        let authService = AuthService(authManager: mockAuthService)
        let signUpViewModel = SignUpViewModel(
            delegate: self as? SignUpViewModelDelegate,
            authService: authService
        )
        let password = "Azerty1*"
        let expect = expectation(description: "Wait for queue change.")

        signUpViewModel.errorHandler = {  message in
            XCTAssertNotNil(message)
            expect.fulfill()
        }
        signUpViewModel.signUpOneUser(fakeName, fakeEmail, password)

        wait(for: [expect], timeout: 3)
    }
}
