//
//  RadioViewModelTests.swift
//  RadiofyTests
//
//  Created by Fabrice Etiennette on 26/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
@testable import Radiofy

class RadioViewModelTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
        UserDefaultConfig.favoriteStations = []
        UserDefaultConfig.recentlyPlayed = []
    }

    func testIfFavoriteWithError() {
        // Given:
        let radio = RadioStation(name: "Radio1", imageURL: "", streamURL: "")
        let radioViewModel = RadioViewModel(selectedRadio: radio)
        let expect = expectation(description: "with success")

        // When:
        let fav = radioViewModel.isRadioFavorite()
        XCTAssertFalse(fav)
        expect.fulfill()

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testIfFavoriteWithSuccess() {
        // Given:
        let radio = RadioStation(name: "Radio1", imageURL: "", streamURL: "")
        let radioViewModel = RadioViewModel(selectedRadio: radio)
        let expect = expectation(description: "with success")

        // When:
        UserDefaultConfig.favoriteStations = ["Radio1"]
        let fav = radioViewModel.isRadioFavorite()
        XCTAssertTrue(fav)
        expect.fulfill()

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testSaveToUserDefaultWithSuccess() {
        // Given:
        let radio = RadioStation(name: "Radio1", imageURL: "", streamURL: "")
        let radioViewModel = RadioViewModel(selectedRadio: radio)
        RadioViewModel.radioStation = radio
        let expect = expectation(description: "with success")

        // When:
        radioViewModel.saveToUserDefaults()
        let favoriteStations = UserDefaultConfig.favoriteStations
        XCTAssertEqual(favoriteStations.count, 1)
        XCTAssertEqual(favoriteStations.first, "Radio1")
        expect.fulfill()

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testDeleteToUserDefaultWithSuccess() {
        // Given:
        let radio = RadioStation(name: "Radio1", imageURL: "", streamURL: "")
        let radioViewModel = RadioViewModel(selectedRadio: radio)
        RadioViewModel.radioStation = radio
        let expect = expectation(description: "with success")

        // When:
        UserDefaultConfig.favoriteStations = ["Radio1"]
        radioViewModel.deleteFromUserDefaults()
        let favoriteStations = UserDefaultConfig.favoriteStations
        XCTAssertEqual(favoriteStations.count, 0)
        expect.fulfill()

        // Then:
        wait(for: [expect], timeout: 3)
    }
}
