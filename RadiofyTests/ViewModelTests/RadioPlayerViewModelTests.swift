//
//  RadioPlayerViewModelTests.swift
//  RadiofyTests
//
//  Created by Fabrice Etiennette on 25/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest
@testable import Radiofy

class RadioPlayerViewModelTests: XCTestCase {

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
        let radioPlayerViewModel = RadioPlayerViewModel(
            delegate: self as? RadioPlayerViewModelDelegate
        )
        let expect = expectation(description: "with success")

        // When:
        let fav = radioPlayerViewModel.isRadioFavorite()
        XCTAssertFalse(fav)
        expect.fulfill()

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testIfFavoriteWithSuccess() {
        // Given:
        let radioPlayerViewModel = RadioPlayerViewModel(
            delegate: self as? RadioPlayerViewModelDelegate
        )
        let radio = RadioStation(name: "Radio1", imageURL: "", streamURL: "")
        radioPlayerViewModel.radio = [radio]
        let expect = expectation(description: "with success")

        // When:
        UserDefaultConfig.favoriteStations = ["Radio1"]
        let fav = radioPlayerViewModel.isRadioFavorite()
        XCTAssertTrue(fav)
        expect.fulfill()

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testSaveToUserDefaultWithSuccess() {
        // Given:
        let radioPlayerViewModel = RadioPlayerViewModel(
            delegate: self as? RadioPlayerViewModelDelegate
        )
        let radio = RadioStation(name: "Radio1", imageURL: "", streamURL: "")
        radioPlayerViewModel.radio = [radio]
        let expect = expectation(description: "with success")

        // When:
        radioPlayerViewModel.saveToUserDefaults()
        let favoriteStations = UserDefaultConfig.favoriteStations
        XCTAssertEqual(favoriteStations.count, 1)
        XCTAssertEqual(favoriteStations.first, "Radio1")
        expect.fulfill()

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testDeleteToUserDefaultWithSuccess() {
        // Given:
        let radioPlayerViewModel = RadioPlayerViewModel(
            delegate: self as? RadioPlayerViewModelDelegate
        )
        let radio = RadioStation(name: "Radio1", imageURL: "", streamURL: "")
        radioPlayerViewModel.radio = [radio]
        let expect = expectation(description: "with success")

        // When:
        UserDefaultConfig.favoriteStations = ["Radio1"]
        radioPlayerViewModel.deleteFromUserDefaults()
        let favoriteStations = UserDefaultConfig.favoriteStations
        XCTAssertEqual(favoriteStations.count, 0)
        expect.fulfill()

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testPlayRadioFromProfilReturnFalse() {
        // Given:
        let radioPlayerViewModel = RadioPlayerViewModel(
            delegate: self as? RadioPlayerViewModelDelegate
        )
        let radio = RadioStation(name: "Radio1", imageURL: "", streamURL: "")
        RadioViewModel.radioStation = radio
        radioPlayerViewModel.radio = [radio]
        let expect = expectation(description: "with success")

        // When:
        radioPlayerViewModel.playFromProfile { radio in
            XCTAssertFalse(radio)
            expect.fulfill()
        }

        // Then:
        wait(for: [expect], timeout: 3)
    }

    func testPlayRadioFromProfilReturnTrue() {
        // Given:
        let radioPlayerViewModel = RadioPlayerViewModel(
            delegate: self as? RadioPlayerViewModelDelegate
        )
        let radio = RadioStation(name: "Radio1", imageURL: "", streamURL: "")
        let radio2 = RadioStation(name: "Radio2", imageURL: "", streamURL: "")
        RadioViewModel.radioStation = radio2
        radioPlayerViewModel.radio = [radio]
        let expect = expectation(description: "with success")

        // When:
        UserDefaultConfig.recentlyPlayed = ["radio1", "radio2", "radio3", "radio4", "radio5"]
        radioPlayerViewModel.radioStarionHandle = { radioStation in
            let radioToCompare = radioStation.first
            let recentlyPlayed = UserDefaultConfig.recentlyPlayed
            XCTAssertEqual(radioToCompare?.name, "Radio2")
            XCTAssertEqual(recentlyPlayed.count, 5)
            expect.fulfill()
        }
        radioPlayerViewModel.playFromProfile { _ in}

        // Then:
        wait(for: [expect], timeout: 3)
    }
}
