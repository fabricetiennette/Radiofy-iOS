//
//  HomeViewModelTests.swift
//  RadiofyTests
//
//  Created by Fabrice Etiennette on 25/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
@testable import Radiofy

class HomeViewModelTests: XCTestCase {

    let fakeName = "Test"
    let imageUrl = "fabrice"
    let streamUrl = "againME"

    var fakeRadioData: [String: Any] = [:]

    var radioStation1 = RadioStation(name: "", imageURL: "", streamURL: "")
    var radioStation2 = RadioStation(name: "", imageURL: "", streamURL: "")

    let id = "xhyAOHONTRtgWjYpgiun"
    var fakeFirestoreDocument = FakeQueryDocumentSnapshot(documentID: "", datas: [:])

    override func setUp() {
        fakeRadioData = ["name": fakeName,
                    "imageURL": imageUrl,
                    "streamURL": streamUrl]

        radioStation1.name = fakeName
        radioStation1.imageURL = imageUrl
        radioStation1.streamURL = streamUrl

        radioStation2.name = fakeName
        radioStation2.imageURL = imageUrl
        radioStation2.streamURL = streamUrl

        fakeFirestoreDocument.documentID = id
        fakeFirestoreDocument.datas = fakeRadioData
    }

    func testGetRecentlyPlayedRadioStations() {
        // Given:
        let query = FakeQuerySnapshot(documents: nil, radio: [radioStation1, radioStation2, radioStation1, radioStation2, radioStation1, radioStation2, radioStation1, radioStation2])
        let fakeFirestoreResponse = FakeFirestoreResponse(
            querySnapshot: query, error: nil
        )
        let mockFirestoreService = MockFirestoreService(
            fakeFirestoreResponse: fakeFirestoreResponse
        )
        let firestoreService = FirestoreService(
            firestoreManager: mockFirestoreService
        )
        let homeViewModel = HomeViewModel(
            delegate: self as? HomeViewModelDelegate,
            firestoreService: firestoreService
        )
        let expect = expectation(description: "Recently played radio :D")

        // When:
        homeViewModel.recentlyPlayedRadioHandler = { radioStation in
            XCTAssertEqual(radioStation.count, 0)
            expect.fulfill()
        }
        homeViewModel.getRecentlyPlayedStationsDetails()

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testGetAllRadioStationsWithFailure() {
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
        let homeViewModel = HomeViewModel(
            delegate: self as? HomeViewModelDelegate,
            firestoreService: firestoreService
        )
        let expect = expectation(description: "No error expected :D")

        // When:
        homeViewModel.errorHandler = { title, message in
            XCTAssertEqual(title, "Error")
            XCTAssertEqual(message, "Could not get radio station, try later")
            expect.fulfill()
        }
        homeViewModel.getAllRadioStations()

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testGetAllRadioStationsWithSuccess() {
        // Given:
        let query = FakeQuerySnapshot(documents: nil, radio: [radioStation1, radioStation2, radioStation1, radioStation2, radioStation1, radioStation2, radioStation1, radioStation2])
        let fakeFirestoreResponse = FakeFirestoreResponse(
            querySnapshot: query, error: nil
        )
        let mockFirestoreService = MockFirestoreService(
            fakeFirestoreResponse: fakeFirestoreResponse
        )
        let firestoreService = FirestoreService(
            firestoreManager: mockFirestoreService
        )
        let homeViewModel = HomeViewModel(
            delegate: self as? HomeViewModelDelegate,
            firestoreService: firestoreService
        )
        let expect = expectation(description: "No error expected :D")

        // When:
        homeViewModel.headerRadioHandler = { allRadio in
            XCTAssertEqual(allRadio.count, 6)
            expect.fulfill()
        }
        homeViewModel.getAllRadioStations()

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testGetNationalRadioStationsWithSuccess() {
        // Given:
        let query = FakeQuerySnapshot(documents: nil, radio: [radioStation1, radioStation2, radioStation1, radioStation2, radioStation1, radioStation2, radioStation1, radioStation2])
        let fakeFirestoreResponse = FakeFirestoreResponse(
            querySnapshot: query, error: nil
        )
        let mockFirestoreService = MockFirestoreService(
            fakeFirestoreResponse: fakeFirestoreResponse
        )
        let firestoreService = FirestoreService(
            firestoreManager: mockFirestoreService
        )
        let homeViewModel = HomeViewModel(
            delegate: self as? HomeViewModelDelegate,
            firestoreService: firestoreService
        )
        let expect = expectation(description: "No error expected :D")

        // When:
        homeViewModel.nationalRadioHandler = { allRadio in
            XCTAssertEqual(allRadio.count, 8)
            expect.fulfill()
        }
        homeViewModel.getNationalStationsDetails()

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testGetNationalRadioStationsWithFailure() {
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
        let homeViewModel = HomeViewModel(
            delegate: self as? HomeViewModelDelegate,
            firestoreService: firestoreService
        )
        let expect = expectation(description: "No error expected :D")

        // When:
        homeViewModel.errorHandler = { title, message in
            XCTAssertEqual(title, "Error")
            XCTAssertEqual(message, "Could not get radio station, try later")
            expect.fulfill()
        }
        homeViewModel.getNationalStationsDetails()

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testGetPopularRadioStationsWithFailure() {
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
        let homeViewModel = HomeViewModel(
            delegate: self as? HomeViewModelDelegate,
            firestoreService: firestoreService
        )
        let expect = expectation(description: "No error expected :D")

        // When:
        homeViewModel.errorHandler = { title, message in
            XCTAssertEqual(title, "Error")
            XCTAssertEqual(message, "Could not get radio station, try later")
            expect.fulfill()
        }
        homeViewModel.getPopularStationsDetails()

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testGetPopularRadioStationsWithSuccess() {
        // Given:
        let query = FakeQuerySnapshot(documents: nil, radio: [radioStation1, radioStation2, radioStation1])
        let fakeFirestoreResponse = FakeFirestoreResponse(
            querySnapshot: query, error: nil
        )
        let mockFirestoreService = MockFirestoreService(
            fakeFirestoreResponse: fakeFirestoreResponse
        )
        let firestoreService = FirestoreService(
            firestoreManager: mockFirestoreService
        )
        let homeViewModel = HomeViewModel(
            delegate: self as? HomeViewModelDelegate,
            firestoreService: firestoreService
        )
        let expect = expectation(description: "No error expected :D")

        // When:
        homeViewModel.popularRadioHandler = { allRadio in
            XCTAssertEqual(allRadio.count, 3)
            expect.fulfill()
        }
        homeViewModel.getPopularStationsDetails()

        // Then:
        wait(for: [expect], timeout: 3)
    }
}
