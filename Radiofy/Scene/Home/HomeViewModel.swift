//
//  HomeViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 28/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Combine

class HomeViewModel: HomeModule.ViewModel {

    // MARK: - Properties

    weak var delegate: HomeModule.CoordinatorDelegate?
    
//    private let firestoreService: FirestoreService

    var errorHandler: ((_ title: String, _ message: String) -> Void)?
    var recentlyPlayedRadioHandler: ((_ stations: [RadioStation]) -> Void)?
    var popularRadioHandler: ((_ stations: [RadioStation]) -> Void)?
    var nationalRadioHandler: ((_ stations: [RadioStation]) -> Void)?
    var headerRadioHandler: ((_ stations: [RadioStation]) -> Void)?

    static var allRadioStations: [RadioStation] = []
    private var headerRadio: [RadioStation] = []
    private var recentlyPlayedStations: [RadioStation] = []
    private var popularStations: [RadioStation] = []
    private var nationalStations: [RadioStation] = []
    private var radioArray = ["stations", "popularStations", "nationalStations"]
    
    private var disposeBag = Set<AnyCancellable>()
    private let service: HomeModule.Service

    // MARK: - Init

    init(service: HomeModule.Service) {
        self.service = service
    }

    // MARK: - Functions

    func getRecentlyPlayedStationsDetails() {
        let recentlyPlayed = UserDefaultConfig.recentlyPlayed
        recentlyPlayedStations = recentlyPlayed.compactMap { radioStationName -> RadioStation? in
            let radioStation = HomeViewModel.allRadioStations.compactMap { radioStation -> RadioStation? in
                if radioStation.name == radioStationName {
                    return radioStation
                }
                return nil
            }
            return radioStation.first
        }
        recentlyPlayedRadioHandler?(recentlyPlayedStations)
        guard let radios = recentlyPlayedStations.first else { return }
        service.saveDocumentToDatabase(imageUrl: radios.imageURL, mainColor: radios.unformattedColor, name: radios.name, streamUrl: radios.streamURL)
    }

    func launchSettingsPage() {
        delegate?.launchSettings()
    }

    func showSelectedRadioPage(with selectedRadio: RadioStation) {
        delegate?.showSelectedRadio(selectedRadio)
    }

    func getAllRadioStations() {
        service.getStationDetails(with: radioArray[0]) { [weak self] result in
            guard let me = self else { return }
            switch result {
            case .success(let radioStation):
                HomeViewModel.allRadioStations = radioStation
                me.headerRadio = HomeViewModel.allRadioStations.pick(6)
                me.headerRadioHandler?(me.headerRadio)
                me.getRecentlyPlayedStationsDetails()
            case .failure:
                me.errorHandler?(L1s.error, L1s.stationUnavailable)
            }
        }
    }

    func getPopularStationsDetails() {
        service.getStationDetails(with: radioArray[1]) { [weak self] result in
            guard let me = self else { return }
            switch result {
            case .success(let radioStation):
                me.popularStations = radioStation
                me.popularRadioHandler?(me.popularStations)
            case .failure:
                me.errorHandler?(L1s.error, L1s.stationUnavailable)
            }
        }
    }

    func getNationalStationsDetails() {
        service.getStationDetails(with: radioArray[2]) { [weak self] result in
            guard let me = self else { return }
            switch result {
            case .success(let radioStation):
                me.nationalStations = radioStation
                me.nationalRadioHandler?(me.nationalStations)
            case .failure:
                me.errorHandler?(L1s.error, L1s.stationUnavailable)
            }
        }
    }

    func verifiedAndFetchRadioStations() {
        service.isFullAppAccessAuthorized { result in
            switch result {
            case .success(let authorization):
                if authorization == false {
                    self.radioArray = ["allStations", "popularStations", "nationalStations"]
                    self.getAllRadioStations()
                    self.getPopularStationsDetails()
                    self.getNationalStationsDetails()
                } else {
                    self.getAllRadioStations()
                    self.getPopularStationsDetails()
                    self.getNationalStationsDetails()
                }
            case .failure: break
            }
        }
    }
}
