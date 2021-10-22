//
//  YourLibraryViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 16/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
import Combine

final class YourLibraryViewModel: YourLibraryModule.ViewModel {

    weak var delegate: YourLibraryModule.CoordinatorDelegate?

    var messageSubject = PassthroughSubject<String, Never>()

    var favorite: [RadioStation] = [] {
        didSet {
            messageSubject.send(L10n.emptyLibraryMessage)
        }
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
    }

    // Show user selected Radio Profile Page
    func showSelectedRadioPage(with selectedRadio: RadioStation) {
        delegate?.selectRadio(selectedRadio)
    }
}
