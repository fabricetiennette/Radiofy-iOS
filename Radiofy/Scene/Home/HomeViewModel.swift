//
//  HomeViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 28/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Combine
import Foundation

class HomeViewModel: HomeModule.ViewModel {

    // MARK: - Delegate

    weak var delegate: HomeModule.CoordinatorDelegate?

    // MARK: - Properties

    var errorSubject = PassthroughSubject<(String, String), Never>()
    var recentlyPlayedSubject = PassthroughSubject<[RadioStation], Never>()
    var popularSubject = PassthroughSubject<[RadioStation], Never>()
    var nationalSubject = PassthroughSubject<[RadioStation], Never>()
    var headerSubject = PassthroughSubject<[RadioStation], Never>()

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
        recentlyPlayedSubject.send(recentlyPlayedStations)

        guard let radios = recentlyPlayedStations.first else { return }
        service.saveDocumentToDatabase(imageUrl: radios.imageURL,
                                       mainColor: radios.unformattedColor,
                                       name: radios.name,
                                       streamUrl: radios.streamURL)
    }

    func launchSettingsPage() {
        delegate?.launchSettings()
    }

    func showSelectedRadioPage(with selectedRadio: RadioStation) {
        delegate?.showSelectedRadio(selectedRadio)
    }

    func getAllRadioStations() {
        service
            .getStationDetails(with: radioArray[0])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure:
                    self.errorSubject.send((L10n.error, L10n.radioTryLater))
                case .finished: break
                }
            } receiveValue: { [weak self] radioStation in
                guard let self = self else { return }
                HomeViewModel.allRadioStations = radioStation
                self.headerRadio = HomeViewModel.allRadioStations.pick(6)
                self.headerSubject.send(self.headerRadio)
                self.getRecentlyPlayedStationsDetails()
            }
            .store(in: &disposeBag)
    }

    func getPopularStationsDetails() {
        service
            .getStationDetails(with: radioArray[1])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure:
                    self.errorSubject.send((L10n.error, L10n.radioTryLater))
                case .finished: break
                }
            } receiveValue: { [weak self] radioStation in
                guard let self = self else { return }
                self.popularStations = radioStation
                self.popularSubject.send(self.popularStations)
            }
            .store(in: &disposeBag)
    }

    func getNationalStationsDetails() {
        service
            .getStationDetails(with: radioArray[2])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure:
                    self.errorSubject.send((L10n.error, L10n.radioTryLater))
                case .finished: break
                }
            } receiveValue: { [weak self] radioStation in
                guard let self = self else { return }
                self.nationalStations = radioStation
                self.nationalSubject.send(self.nationalStations)
            }
            .store(in: &disposeBag)
    }

    func verifiedAndFetchRadioStations() {
        service
            .isFullAppAccessAuthorized()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard self != nil else { return }
                switch result {
                case .finished: break
                case .failure: break
                }
            } receiveValue: { [weak self] authorization in
                guard let self = self else { return }
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
            }
            .store(in: &disposeBag)
    }
}
