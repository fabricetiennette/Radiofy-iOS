//
//  NationStationsCollectionViewCell.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 11/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import FirebaseUI

class NationalStationsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nationalStationsImageView: UIImageView!
    @IBOutlet weak var nationalStationsLabel: UILabel!

    func configureCell(station: RadioStation) {

        let url = URL(string: station.imageURL)
        nationalStationsImageView.sd_setImage(with: url, completed: nil)
        nationalStationsLabel.text = station.name
    }
}
