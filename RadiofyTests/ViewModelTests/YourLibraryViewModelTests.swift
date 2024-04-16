//
//  YourLibraryViewModelTests.swift
//  RadiofyTests
//
//  Created by Fabrice Etiennette on 26/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
@testable import Radiofy

class YourLibraryViewModelTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
        UserDefaultConfig.favoriteStations = []
    }

    func testIfThereiSFavoriteWithSuccess() {
        // Given:
        let radio = RadioStation(name: "Radio1", imageURL: "", streamURL: "", unformattedColor: "")
        let yourLibraryViewModel = YourLibraryViewModel(
            delegate: self as? YourLibraryViewModelDelegate
        )
        yourLibraryViewModel.favorite = []
        let expect = expectation(description: "with success")

        // When:
        UserDefaultConfig.favoriteStations = ["Radio1"]
        HomeViewModel.allRadioStations = [radio]
        yourLibraryViewModel.favoriteStationsHandler = { _ in
            XCTAssertEqual(yourLibraryViewModel.favorite.count, 1)
            XCTAssertEqual(yourLibraryViewModel.favorite.first?.name, "Radio1")
            expect.fulfill()
        }
        yourLibraryViewModel.getFavoritesRadioStations()

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testIfThereiSFavoriteWithNil() {
        // Given:
        let radio = RadioStation(name: "Radio2", imageURL: "", streamURL: "", unformattedColor: "")
        let yourLibraryViewModel = YourLibraryViewModel(
            delegate: self as? YourLibraryViewModelDelegate
        )
        yourLibraryViewModel.favorite = [radio]
        let expect = expectation(description: "with success")

        // When:
        UserDefaultConfig.favoriteStations = ["Radio1"]
        HomeViewModel.allRadioStations = [radio]
        yourLibraryViewModel.favoriteStationsHandler = { allRadio in
            XCTAssertEqual(allRadio.count, 0)
            expect.fulfill()
        }
        yourLibraryViewModel.getFavoritesRadioStations()

        // Then:
        wait(for: [expect], timeout: 3)
    }
}
