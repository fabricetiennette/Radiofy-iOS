// swiftlint:disable force_cast
//
//  EpisodeDataSource.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 30/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class EpisodeDataSource: NSObject, UITableViewDataSource {

    var episodeTapHandler: ((_ episode: Episode) -> Void)?

    private var episodes: [Episode] = []

    func updateCell(with episode: [Episode]) {
        self.episodes = episode
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return episodes.count
        default: return 1
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let episode = episodes.first
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "EpisodeHeaderCell",
                for: indexPath) as! EpisodeHeaderCell
            cell.configureCell(episode: episode)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "EpisodeCell", for: indexPath) as! EpisodeCell
            cell.configureCell(episode: episodes[indexPath.row], indexPath: indexPath)
            return cell
        default: break
        }
        return UITableViewCell()
    }
}

extension EpisodeDataSource: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 300
        default: return 125
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            guard indexPath.row < episodes.count else { return }
            episodeTapHandler?(episodes[indexPath.row])
        default: break
        }
    }
}
