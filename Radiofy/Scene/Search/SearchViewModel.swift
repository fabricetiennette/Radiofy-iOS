//
//  SearchViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 18/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Combine

final class SearchViewModel: SearchModule.ViewModel {

    weak var delegate: SearchModule.CoordinatorDelegate?

    var updateAllStationsSubject = PassthroughSubject<[RadioStation], Never>()

    // Get all Radio Stations available
    func getAllRadioStations() {
        updateAllStationsSubject.send(HomeViewModel.allRadioStations)
    }

    // Show user selected Radio Profile Page
    func showSelectedRadioPage(with selectedRadio: RadioStation) {
        delegate?.selectRadio(selectedRadio)
    }
}
