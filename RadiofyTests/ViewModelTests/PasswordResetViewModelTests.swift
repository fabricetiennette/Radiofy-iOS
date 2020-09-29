//
//  PasswordResetViewModelTests.swift
//  RadiofyTests
//
//  Created by Fabrice Etiennette on 25/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
@testable import Radiofy

class PasswordResetViewModelTests: XCTestCase {

    let fakeName = "tester"
    let fakeEmail = "tests@radiofy.com"
    var fakeAuthDataResult = FakeAuthDataResult(
        user: FakeUser(displayName: "", email: "")
    )

    override func setUp() {
        fakeAuthDataResult.user?.displayName = fakeName
        fakeAuthDataResult.user?.email = fakeEmail
    }

    func testEmailIsInValideWhileAttempingToResetPassword() {
        // Given:
        let fakeAuthResponse = FakeAuthResponse(
            authDataResult: fakeAuthDataResult, error: nil
        )
        let mockAuthService = MockAuthService(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authManager: mockAuthService)
        let passwordResetViewModel = PasswordResetViewModel(
            authService: authService
        )
        let email = "test@"
        let expect = expectation(description: "Email error expected :D")

        // When:
        passwordResetViewModel.errorHandler = { message in
            XCTAssertEqual(message, "Email entered is not valid.")
            expect.fulfill()
        }
        passwordResetViewModel.resetPassword(with: email)

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testEmailIsValideWhileAttempingToResetPassword() {
        // Given:
        let fakeAuthResponse = FakeAuthResponse(
            authDataResult: fakeAuthDataResult, error: nil
        )
        let mockAuthService = MockAuthService(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authManager: mockAuthService)
        let passwordResetViewModel = PasswordResetViewModel(
            authService: authService
        )
        let email = "test@Radiofy.io"
        let expect = expectation(description: "Email error expected :D")

        // When:
        passwordResetViewModel.emailSuccessfullHandler = { message in
            XCTAssertEqual(message, "An email was send to \(email).")
            expect.fulfill()
        }
        passwordResetViewModel.resetPassword(with: email)

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testResetPasswordWillEndWithFailure() {
        // Given:
        let fakeAuthResponse = FakeAuthResponse(
            authDataResult: nil,
            error: FakeNetworkResponse.networkError
        )
        let mockAuthService = MockAuthService(fakeAuthResponse: fakeAuthResponse)
        let authService = AuthService(authManager: mockAuthService)
        let passwordResetViewModel = PasswordResetViewModel(
            authService: authService
        )
        let email = "test@Radiofy.io"
        let expect = expectation(description: "Email error expected :D")

        // When:
        passwordResetViewModel.errorHandler = { message in
            XCTAssertNotNil(message)
            expect.fulfill()
        }
        passwordResetViewModel.resetPassword(with: email)

        // Then:
        wait(for: [expect], timeout: 3)
    }
}
