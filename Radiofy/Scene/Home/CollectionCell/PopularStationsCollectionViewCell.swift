//
//  PopularStationsCollectionViewCell.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 11/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import Firebase

class PopularStationsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var popularStationImageView: UIImageView!
    @IBOutlet weak var popularStationLabel: UILabel!

    func configureCell(station: RadioStation) {

        let url = URL(string: station.imageURL)
        popularStationImageView.sd_setImage(with: url, completed: nil)
        popularStationLabel.text = station.name
    }
}
