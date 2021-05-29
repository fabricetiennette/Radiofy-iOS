//
//  ListPodcastCell.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 30/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import SDWebImage

class ListPodcastCell: UITableViewCell {

    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var podcastNameLabel: UILabel!
    @IBOutlet weak var podcastRadioNameLabel: UILabel!
    @IBOutlet weak var podcastEpisodeLabel: UILabel!

    func configureCell(podcast: Podcast, indexPath: IndexPath) {

        guard let url = URL(string: podcast.artworkUrl600!),
            let epidsodeCount = podcast.trackCount
            else { return }

        podcastImageView.sd_setImage(with: url, completed: nil)
        podcastNameLabel.text = podcast.trackName
        podcastRadioNameLabel.text = podcast.artistName
        podcastEpisodeLabel.text = "\(epidsodeCount) \(L1s.episodes)"
    }
}
