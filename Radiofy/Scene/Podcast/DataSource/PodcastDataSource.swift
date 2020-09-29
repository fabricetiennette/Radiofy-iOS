// swiftlint:disable force_cast
//
//  PodcastDataSource.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 30/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class PodcastDataSource: NSObject, UITableViewDataSource {

    var didTapPodcastStationHandler: ((_ podcast: PodcastStation) -> Void)?

    private var podcastStations: [PodcastStation] = []
    private var searchpodcastStation: [PodcastStation] = []

    func updateCell(with podcast: [PodcastStation]) {
        self.podcastStations = podcast
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return podcastStations.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let podcastStation = podcastStations[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "podcastCell", for: indexPath) as! PodcastCell
        cell.configureCell(podcastStation: podcastStation, indexPath: indexPath)
        return cell
    }
}

extension PodcastDataSource: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 125
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < podcastStations.count else { return }
        didTapPodcastStationHandler?(podcastStations[indexPath.row])
    }
}
