//
//  RadioViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 11/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation
import Combine

final class RadioViewModel: RadioModule.ViewModel {

    weak var delegate: RadioModule.CoordinatorDelegate?

    var radioDetailsSubject = PassthroughSubject<RadioStation, Never>()

    // Check if selected radio is a favorite
    var isRadioFavorite: Bool {
        let favoriteStations = UserDefaultConfig.favoriteStations
        if favoriteStations.contains(where: {$0 == radio.name}) {
            return true
        }
        return false
    }

    static let NotificationPlayPressed = NSNotification.Name(rawValue: "Play")
    static var radioStation: RadioStation?
    private var radio: RadioStation {
        didSet {
            showRadioDetails()
        }
    }

    init(radio: RadioStation) {
        self.radio = radio
    }

    // Save a new Radio to favorite
    func saveToUserDefaults() {
        var favoriteStations = UserDefaultConfig.favoriteStations
        favoriteStations.insert(radio.name, at: 0)
        let radioName = favoriteStations.unique()
        UserDefaultConfig.favoriteStations = radioName
    }

    // Delete one radio from favorite list
    func deleteFromUserDefaults() {
        var favoriteStations = UserDefaultConfig.favoriteStations
        if let index = favoriteStations.firstIndex(of: radio.name) {
            favoriteStations.remove(at: index)
            UserDefaultConfig.favoriteStations = favoriteStations
        }
    }

    func showRadioDetails() {
        radioDetailsSubject.send(radio)
    }

    private func notificationSendToPlayer() {
        NotificationCenter.default.post(name: RadioViewModel.NotificationPlayPressed, object: nil)
    }

    func playRadio() {
        RadioViewModel.radioStation = radio
        notificationSendToPlayer()
    }

    func showPayWall() {
        delegate?.openPayWallView()
    }
}
