//
//  YourLibraryViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 16/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation

protocol YourLibraryViewModelDelegate: AnyObject {
    func selectRadio(_ selectedradio: RadioStation)
}

class YourLibraryViewModel {

    private weak var delegate: YourLibraryViewModelDelegate?

    var favoriteStationsHandler: ((_ stations: [RadioStation]) -> Void)?
    var messageHandler: (_ text: String) -> Void = { _ in }

    private let defaults = UserDefaults.standard
    var favorite: [RadioStation] = [] {
        didSet {
            messageHandler(L1s.emptyLibraryMessage)
        }
    }

    init(delegate: YourLibraryViewModelDelegate?) {
        self.delegate = delegate
    }

    // Get Favorite radio stations from all radio stations list
    func getFavoritesRadioStations() {
        let favoriteStations = UserDefaultConfig.favoriteStations
        favorite = favoriteStations.compactMap { radioStationName -> RadioStation? in
            let radioStation = HomeViewModel.allRadioStations.compactMap { radioStation -> RadioStation? in
                if radioStation.name == radioStationName {
                    return radioStation
                }
                return nil
            }
            return radioStation.first
        }
        favoriteStationsHandler?(favorite)
    }

    // Show user selected Radio Profile Page
    func showSelectedRadioPage(with selectedRadio: RadioStation) {
        delegate?.selectRadio(selectedRadio)
    }
}
