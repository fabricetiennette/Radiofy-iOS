//
//  SignOutTableViewCell.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 01/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

protocol SignOutTableViewCellDelegate: AnyObject {
    func signOutButtonPressed()
}

class SignOutTableViewCell: UITableViewCell {

    @IBOutlet private weak var signOutButton: UIButton!

    weak var delegate: SignOutTableViewCellDelegate?

    @IBAction private func signOutButtonTapped(_ sender: Any) {
        delegate?.signOutButtonPressed()
    }
}
