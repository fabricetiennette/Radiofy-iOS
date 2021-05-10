//
//  SearchViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 18/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation

protocol SearchViewModelDelegate: AnyObject {
    func selectRadio(_ selectedradio: RadioStation)
}

class SearchViewModel {

    private weak var delegate: SearchViewModelDelegate?

    var updateAllStationsHandler: ((_ stations: [RadioStation]) -> Void)?

    private var allRadioStations: [RadioStation] = []

    init(delegate: SearchViewModelDelegate?) {
        self.delegate = delegate
    }

    // Get all Radio Stations available
    func getAllRadioStations() {
        let allStations = HomeViewModel.allRadioStations
        allRadioStations = allStations
        updateAllStationsHandler?(allRadioStations)
    }

    // Show user selected Radio Profile Page
    func showSelectedRadioPage(with selectedRadio: RadioStation) {
        delegate?.selectRadio(selectedRadio)
    }
}
