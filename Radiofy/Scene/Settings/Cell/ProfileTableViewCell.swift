//
//  ProfileTableViewCell.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 02/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

protocol ProfileTableViewCellDelegate: AnyObject {
    func editProfilePressed()
}

class ProfileTableViewCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    var backgroundColorHandler: ((_ mainColor: UIColor) -> Void)?
    weak var delegate: ProfileTableViewCellDelegate?

    @IBAction func editProfileTapped(_ sender: Any) {
        delegate?.editProfilePressed()
    }

    // MARK: - Configuration

    func configureCell(userName: String, imageRef: StorageReference?) {
        nameLabel.text = userName

        #warning("TODO: not working need to be fixed")
        guard let ref = imageRef else { return }
        profileImageView.setImage(with: ref) { [weak self ] color in
            guard let me = self else { return }
            guard let mainColor = color else { return }
            DispatchQueue.main.async {
                me.backgroundColorHandler?(mainColor)
            }
        }

        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderColor? = UIColor.clear.cgColor
        profileImageView.layer.borderWidth = 1
    }
}
