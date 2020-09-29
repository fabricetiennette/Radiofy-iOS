//
//  RadioViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 11/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation

protocol RadioViewModelDelegate: class {
    func openPayWallView()
}

class RadioViewModel {

    private weak var delegate: RadioViewModelDelegate?

    var radioDetailsHandler: ((_ selectedRadio: RadioStation) -> Void)?

    static let NotificationPlayPressed = NSNotification.Name(rawValue: "Play")
    static var radioStation: RadioStation?
    private var selectedRadio: RadioStation?

    init(delegate: RadioViewModelDelegate?, selectedRadio: RadioStation?) {
        self.delegate = delegate
        self.selectedRadio = selectedRadio

        showRadioDetails()
    }

    // Check if selected radio is a favorite
    func isRadioFavorite() -> Bool {
        let favoriteStations = UserDefaultConfig.favoriteStations
        if favoriteStations.contains(where: {$0 == selectedRadio?.name}) {
            return true
        }
        return false
    }

    // Save a new Radio to favorite
    func saveToUserDefaults() {
        var favoriteStations = UserDefaultConfig.favoriteStations
        if let newFavorite = selectedRadio?.name {
            favoriteStations.insert(newFavorite, at: 0)
            let radioName = favoriteStations.unique()
            UserDefaultConfig.favoriteStations = radioName
        }
    }

    // Delete one radio from favorite list
    func deleteFromUserDefaults() {
        var favoriteStations = UserDefaultConfig.favoriteStations
        guard let name = selectedRadio?.name else { return }
        if let index = favoriteStations.firstIndex(of: name) {
            favoriteStations.remove(at: index)
            UserDefaultConfig.favoriteStations = favoriteStations
        }
    }

    func showRadioDetails() {
        guard let selectedRadio = self.selectedRadio else { return }
        radioDetailsHandler?(selectedRadio)
    }

    private func notificationSendToPlayer() {
        NotificationCenter.default.post(name: RadioViewModel.NotificationPlayPressed, object: nil)
    }

    func playRadio() {
        guard let selectedRadio = self.selectedRadio else { return }
        RadioViewModel.radioStation = selectedRadio
        notificationSendToPlayer()
    }

    func showPayWall() {
        delegate?.openPayWallView()
    }
}
