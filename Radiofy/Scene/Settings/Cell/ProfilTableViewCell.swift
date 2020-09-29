//
//  ProfileTableViewCell.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 02/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var forwardIcon: UIImageView!

    // MARK: - Configuration

    func configureCell() {

        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderColor? = UIColor.clear.cgColor
        profileImageView.layer.borderWidth = 1

        let tintedImage = forwardIcon?.image?.withRenderingMode(.alwaysTemplate)
        forwardIcon.image = tintedImage
        forwardIcon.tintColor = .white
    }
}
