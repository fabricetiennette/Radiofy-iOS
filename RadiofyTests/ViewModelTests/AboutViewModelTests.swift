//
//  AboutViewModelTests.swift
//  RadiofyTests
//
//  Created by Fabrice Etiennette on 27/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
@testable import Radiofy

class AboutViewModelTests: XCTestCase {

    func testOpenPrivacyRulesWithFailure() {
        // Given:
        let fakeFirestoreResponse = FakeFirestoreResponse(
            querySnapshot: nil, error: FakeNetworkResponse.networkError
        )
        let mockFirestoreService = MockFirestoreService(
            fakeFirestoreResponse: fakeFirestoreResponse
        )
        let firestoreService = FirestoreService(
            firestoreManager: mockFirestoreService
        )
        let aboutViewModel = AboutViewModel(firestoreService: firestoreService)
        let expect = expectation(description: "Email error expected :D")

        // When:
        aboutViewModel.errorHandler = { title, message in
            XCTAssertEqual(title, "Error")
            XCTAssertEqual(message, "Could not open document, try later.")
            expect.fulfill()
        }
        aboutViewModel.showSafariView(with: .privacy)

        // Then:
        wait(for: [expect], timeout: 3)
    }
}
