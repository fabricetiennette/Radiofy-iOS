//
//  EpisodeViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 30/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation

protocol EpisodeViewModelDelegate: AnyObject {
    func payWallView()
}

class EpisodeViewModel {

    private weak var delegate: EpisodeViewModelDelegate?

    var episodeHandler: ((_ episodes: [Episode]) -> Void)?
    var errorHandler: ((_ title: String, _ message: String) -> Void)?

    static let NotificationEpisode = NSNotification.Name(rawValue: "PlayEpisode")
    private let podcastService: PodcastService
    private var allEpisodes: [Episode] = []
    static var episode: [Episode] = []
    var selectedPodcast: Podcast?

    init(
        delegate: EpisodeViewModelDelegate?,
        selectedPodcast: Podcast,
        podcastService: PodcastService = .init()
    ) {
        self.delegate = delegate
        self.selectedPodcast = selectedPodcast
        self.podcastService = podcastService

    }

    func getEpisode() {
        guard let feedUrl = selectedPodcast?.feedUrl else {
            errorHandler?(L10n.errorUnavailable, "\(selectedPodcast?.trackName ?? "Podcast") \(L10n.isTemporarilyUnavailable)")
            return
        }
        podcastService.fetchEpisodes(feedUrl: feedUrl) { result in
            switch result {
            case .success(let allEpisodes):
                self.allEpisodes = allEpisodes
                self.episodeHandler?(self.allEpisodes)
            case .failure(let error):
                self.errorHandler?(L10n.error, error.localizedDescription)
            }
        }
    }

    private func notificationSendToPlayer() {
        NotificationCenter.default.post(name: EpisodeViewModel.NotificationEpisode, object: nil)
    }

    func getAndPlayEpisode(with episode: Episode) {
        EpisodeViewModel.episode.removeAll()
        EpisodeViewModel.episode.append(episode)
        notificationSendToPlayer()
    }

    func showPayWall() {
        delegate?.payWallView()
    }
}
