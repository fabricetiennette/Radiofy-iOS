//
//  EditProfileViewModelTests.swift
//  RadiofyTests
//
//  Created by Fabrice Etiennette on 26/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
@testable import Radiofy

class EditProfileViewModelTests: XCTestCase {

    let fakeName = "tester"
    let fakeEmail = "testing@radiofy.com"
    var fakeAuthDataResult = FakeAuthDataResult(user: FakeUser(displayName: "", email: ""))

    override func setUp() {
           fakeAuthDataResult.user?.displayName = fakeName
           fakeAuthDataResult.user?.email = fakeEmail
    }

    func testUsernameWithFailure() {
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
        let authService = AuthService(LegacyFirebaseAuthManager: mockAuthService)
        let editProfileViewModel = EditProfileViewModel(authService: authService, firestoreService: firestoreService, storageService: storageService)
        let imageView = UIImageView()
        imageView.image = UIImage(named: "NoPicture")
        let data = imageView.image?.pngData()
        let expect = expectation(description: "Email error expected :D")

        // When:
        editProfileViewModel.errorHandler = { error in
            XCTAssertNotNil(error)
            expect.fulfill()
        }
        editProfileViewModel.saveUserInfo(data, "fab")

        // Then:
        wait(for: [expect], timeout: 3)
    }
}
