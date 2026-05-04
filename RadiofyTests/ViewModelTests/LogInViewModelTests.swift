//
//  LogInViewModelTests.swift
//  RadiofyTests
//
//  Created by Fabrice Etiennette on 24/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
@testable import Radiofy

class LogInViewModelTests: XCTestCase {

    let fakeName = "tester"
    let fakeEmail = "tests@radiofy.com"
    var fakeAuthDataResult = FakeAuthDataResult(
        user: FakeUser(displayName: "", email: "")
    )

    override func setUp() {
        fakeAuthDataResult.user?.displayName = fakeName
        fakeAuthDataResult.user?.email = fakeEmail
    }

    func testEmailIsInValideWhileAttempingToLogIn() {
        // Given:
        let fakeAuthResponse = FakeAuthResponse(
            authDataResult: fakeAuthDataResult, error: nil
        )
        let mockAuthService = MockAuthService(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(LegacyFirebaseAuthManager: mockAuthService)
        let logInViewModel = LogInViewModel(
            delegate: self as? LogInViewModelDelegate,
            authService: authService
        )
        let email = "slashteuf"
        let password = "Azerty12*"
        let expect = expectation(description: "Email error expected :D")

        // When:
        logInViewModel.errorHandler = { message in
            XCTAssertEqual(message, "Email entered is not valid.")
            expect.fulfill()
        }
        logInViewModel.logInUser(with: email, password)

        // Then:
        wait(for: [expect], timeout: 10)
    }

    func testPasswordIsInvalidWhileAttempingToLogIn() {
        // Given:
        let fakeAuthResponse = FakeAuthResponse(
            authDataResult: fakeAuthDataResult, error: nil
        )
        let mockAuthService = MockAuthService(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(LegacyFirebaseAuthManager: mockAuthService)
        let logInViewModel = LogInViewModel(
            delegate: self as? LogInViewModelDelegate,
            authService: authService
        )
        let email = "test@Radiofy.com"
        let password = "Azerty1"
        let expect = expectation(description: "Email error expected :D")

        // When:
        logInViewModel.errorHandler = { message in
            XCTAssertEqual(message, "Please make sure your password contain a least 8 characters, one special character and a number.")
            expect.fulfill()
        }
        logInViewModel.logInUser(with: email, password)

        // Then:
        wait(for: [expect], timeout: 10)
    }

    func testUserLogInShouldReturnOkay() {
        // Given:
        let fakeAuthResponse = FakeAuthResponse(
            authDataResult: fakeAuthDataResult, error: nil
        )
        let mockAuthService = MockAuthService(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(LegacyFirebaseAuthManager: mockAuthService)
        let logInViewModel = LogInViewModel(
            delegate: self as? LogInViewModelDelegate,
            authService: authService
        )
        let email = "test@Radiofy.com"
        let password = "Azerty10@"
        let expect = expectation(description: "Email error expected :D")

        // When:
        logInViewModel.errorHandler = { message in
            XCTFail(message)
        }
        logInViewModel.logInUser(with: email, password)
        expect.fulfill()

        // Then:
        wait(for: [expect], timeout: 10)
    }

    func testLogInUserIsNilShouldRetureFailure() {
        // Given:
        let fakeAuthResponse = FakeAuthResponse(
            authDataResult: nil, error: FakeNetworkResponse.networkError
        )
        let mockAuthService = MockAuthService(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(LegacyFirebaseAuthManager: mockAuthService)
        let logInViewModel = LogInViewModel(
            delegate: self as? LogInViewModelDelegate,
            authService: authService
        )
        let email = "test@Radiofy.com"
        let password = "Azerty10@"
        let expect = expectation(description: "Email error expected :D")

        // When:
        logInViewModel.errorHandler = { message in
            XCTAssertNotNil(message)
            expect.fulfill()
        }
        logInViewModel.logInUser(with: email, password)

        // Then:
        wait(for: [expect], timeout: 10)
    }

    func testLogInUserEmailIsNotVerified() {
        // Given:
        let fakeAuthResponse = FakeAuthResponse(
            authDataResult: fakeAuthDataResult, error: nil
        )
        let mockAuthService = EmailMock(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(LegacyFirebaseAuthManager: mockAuthService)
        let logInViewModel = LogInViewModel(
            delegate: self as? LogInViewModelDelegate,
            authService: authService
        )
        let email = "unknown@radiofy.com"
        let password = "Azerty10@"
        let expect = expectation(description: "Email error expected :D")

        // When:
        logInViewModel.errorHandler = { message in
            XCTAssertEqual(message, "Please verified your email first")
            expect.fulfill()
        }
        logInViewModel.logInUser(with: email, password)

        // Then:
        wait(for: [expect], timeout: 3)
    }
}
