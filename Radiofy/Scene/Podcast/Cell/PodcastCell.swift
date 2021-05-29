//
//  PodcastCell.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 30/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import SDWebImage

class PodcastCell: UITableViewCell {

    @IBOutlet weak var podcastImageMain: UIImageView!
    @IBOutlet weak var podcastRadioNameMain: UILabel!

    func configureCell(podcastStation: PodcastStation, indexPath: IndexPath) {

        podcastRadioNameMain.text = podcastStation.name
        guard let url = URL(string: podcastStation.imageUrl) else { return }
        podcastImageMain.sd_setImage(with: url, completed: nil)
    }
}
