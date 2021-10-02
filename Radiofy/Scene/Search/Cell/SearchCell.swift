//
//  SearchCell.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 17/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import SDWebImage
import Reusable

final class SearchCell: UICollectionViewCell, NibReusable {

    @IBOutlet private weak var magicalView: UIView!
    @IBOutlet private weak var radioNameLabel: UILabel!
    @IBOutlet private weak var radioImageView: SearchImageView!

    func configureCell(station: RadioStation, indexPath: IndexPath) {
        // Name
        radioNameLabel.text = station.name

        // Image
        let url = URL(string: station.imageURL)
        radioImageView.sd_setImage(with: url, completed: nil)

        // BackgroundColor
        magicalView.backgroundColor = station.color
    }
}
