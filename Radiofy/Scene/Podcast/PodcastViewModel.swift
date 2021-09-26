//
//  PodcastViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 30/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation

protocol PodcastViewModelDelegate: AnyObject {
    func selectPocastStation(_ selectedPodcast: PodcastStation)
}

class PodcastViewModel {

    private weak var delegate: PodcastViewModelDelegate?

    var errorHandler: ((_ title: String, _ message: String) -> Void)?
    var allPodcastStationsHandler: ((_ podcast: [PodcastStation]) -> Void)?

    private let firestoreService: FirestoreService

    var podcastArray = ["podcast"]
    var podcastStation: [PodcastStation] = []

    init(
        delegate: PodcastViewModelDelegate?,
        firestoreService: FirestoreService = .init()
    ) {
        self.delegate = delegate
        self.firestoreService = firestoreService
    }

    // Show user selected Podcast Station Page
    func showSelectedPodcastStation(with selectedPodcast: PodcastStation) {
        delegate?.selectPocastStation(selectedPodcast)
    }

    // Get podcaststation from database
    func getPodcastStation() {
        firestoreService.getPodcastStationFromDatabase(with: podcastArray[0]) { result in
            switch result {
            case .success(let podcastStations):
                self.podcastStation = podcastStations
                self.allPodcastStationsHandler?(self.podcastStation)
            case .failure(let error):
                self.errorHandler?(L10n.error, error.localizedDescription)
            }
        }
    }

    func verifiedAndFetchPodcastStations() {
        firestoreService.isFullAppAccessAuthorized { result in
            switch result {
            case .success(let authorization):
                if authorization == false {
                    self.podcastArray = ["podcastStations"]
                    self.getPodcastStation()
                } else {
                    self.getPodcastStation()
                }
            case .failure: break
            }
        }
    }
}
