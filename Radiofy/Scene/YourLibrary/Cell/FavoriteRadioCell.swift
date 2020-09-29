//
//  FavoriteRadioCell.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 16/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class FavoriteRadioCell: UITableViewCell {

    @IBOutlet weak var radioImageview: UIImageView!
    @IBOutlet weak var radioLabel: UILabel!

    func configureCell(station: RadioStation, indexPath: IndexPath) {

        let url = URL(string: station.imageURL)
        radioImageview.sd_setImage(with: url, completed: nil)
        radioLabel.text = station.name
    }
}
