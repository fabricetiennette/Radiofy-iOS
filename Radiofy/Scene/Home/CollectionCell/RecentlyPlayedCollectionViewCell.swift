//
//  RecentlyPlayedCollectionViewCell.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 08/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import SDWebImage

class RecentlyPlayedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var recentlyPlayedImageView: UIImageView!
    @IBOutlet weak var recentlyPlayedLabel: UILabel!

    func configureCell(station: RadioStation) {

        let url = URL(string: station.imageURL)
        recentlyPlayedImageView.sd_setImage(with: url, completed: nil)
        recentlyPlayedLabel.text = station.name

        recentlyPlayedImageView.layer.cornerRadius = recentlyPlayedImageView.frame.size.width / 2
        recentlyPlayedImageView.layer.masksToBounds = true
    }
}
