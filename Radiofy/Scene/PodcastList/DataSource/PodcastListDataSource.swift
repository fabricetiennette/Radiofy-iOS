// swiftlint:disable force_cast
//
//  PodcastListDataSource.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 30/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class PodcastListDataSource: NSObject, UITableViewDataSource {

    var podcastTapHandle: ((_ podcast: Podcast) -> Void)?

    private var podcasts: [Podcast] = []

    func updateCell(with podcasts: [Podcast]) {
        self.podcasts = podcasts
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return podcasts.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let podcast = podcasts[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ListPodcastCell", for: indexPath) as! ListPodcastCell
        cell.configureCell(podcast: podcast, indexPath: indexPath)
        return cell
    }
}

extension PodcastListDataSource: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 125
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard indexPath.row < podcasts.count else { return }
        podcastTapHandle?(podcasts[indexPath.row])
    }
}
