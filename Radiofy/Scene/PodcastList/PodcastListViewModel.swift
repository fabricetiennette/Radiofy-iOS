//
//  PodcastListViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 30/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation

protocol PodcastListViewModelDelegate: class {
    func showSelectedPodcastEpisode(_ selectedEpisode: Podcast)
}

class PodcastListViewModel {

    private weak var delegate: PodcastListViewModelDelegate?

    var podcastServiceHandler: ((_ podcasts: [Podcast]) -> Void)?
    var errorHandler: ((_ title: String, _ message: String) -> Void)?

    private let podcastService: PodcastService
    private var podcastStation: PodcastStation?
    private let firestoreService: FirestoreService
    var podcasts: [Podcast] = []
    var allRadioPodcasts: [RadioPodcast] = []
    var title: String?

    init(
        delegate: PodcastListViewModelDelegate?,
        selectedPodcastStation: PodcastStation,
        podcastService: PodcastService = .init(),
        firestoreService: FirestoreService = .init()
    ) {
        self.delegate = delegate
        self.podcastStation = selectedPodcastStation
        self.podcastService = podcastService
        self.firestoreService = firestoreService
        self.title = podcastStation?.name

        getAllMissingPodcast()
        getPodcast()
    }

    func getPodcast() {
        guard let searchText = podcastStation?.searchName else { return }
        podcastService.fetchPodcasts(searchText: searchText) { result in
            switch result {
            case .success(let podcasts):
            self.podcasts =  podcasts
            self.podcastServiceHandler?(self.podcasts)
            case .failure(let error):
                self.errorHandler?(L1s.error, error.localizedDescription)
            }
        }
    }

    func getAllMissingPodcast() {
        firestoreService.getRadioPodcastFromDatabase(with: "radioPodcast") { result in
            switch result {
            case .success(let allMissingPodcast):
                self.allRadioPodcasts = allMissingPodcast
            case .failure(let error):
                self.errorHandler?(L1s.error, error.localizedDescription)
            }
        }
    }

    func showEpisodeView(with episodePodcast: Podcast) {
        let episode = isFeedUrlMissing(in: episodePodcast)
        delegate?.showSelectedPodcastEpisode(episode)
    }

    private func isFeedUrlMissing(in episodePodcast: Podcast) -> Podcast {
        let episode = episodePodcast
        let feedUrl = allRadioPodcasts.compactMap { podcast -> String? in
            if podcast.name == episode.trackName {
                return podcast.feedURL
            }
            return episode.feedUrl
        }
        episode.feedUrl = feedUrl.first
        return episode
    }
}
