//
//  SearchViewModelTests.swift
//  RadiofyTests
//
//  Created by Fabrice Etiennette on 26/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

//
//import XCTest
//@testable import Radiofy
//
//class SearchViewModelTests: XCTestCase {
//
//    func testGetAllRadioStationsWithSuccess() {
//        // Given:
//        let radio = RadioStation(name: "Radio1", imageURL: "", streamURL: "")
//        let searchViewModel = SearchViewModel(delegate: self as? SearchViewModelDelegate)
//        HomeViewModel.allRadioStations = [radio]
//        let expect = expectation(description: "with success")
//
//        // When:
//        searchViewModel.updateAllStationsHandler = { allRadioStations in
//            XCTAssertEqual(allRadioStations.count, 1)
//            XCTAssertEqual(allRadioStations.first?.name, "Radio1")
//            expect.fulfill()
//        }
//        searchViewModel.getAllRadioStations()
//
//        // Then:
//        wait(for: [expect], timeout: 3)
//    }
//}
