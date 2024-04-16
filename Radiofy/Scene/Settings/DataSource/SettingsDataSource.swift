// swiftlint:disable force_cast
//
//  SettingsDataSource.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 01/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import FirebaseStorage

#warning("move to viewcontroller")
class SettingsDataSource: NSObject, UITableViewDataSource {

    // MARK: - Properties

    var accountTappedHandler: (() -> Void)?
    var aboutTappedHandler: (() -> Void)?
    var signOutHandler: (() -> Void)?
    var editProfileHandler: (() -> Void)?
    var mainColorHandler: ((_ color: UIColor) -> Void)?
    var profilInfoHandler: ((_ userName: String, _ userPhotoUrl: String) -> Void)?

    private var name = ""
    private var reference: StorageReference?

    func updateCellUserName(_ userName: String) {
        self.name = userName
    }

    func updateCellPhoto(_ photoReference: StorageReference) {
        self.reference = photoReference
    }

    // MARK: - DataSource

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        tableView.accessibilityIdentifier = "SettingTableView"
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
            cell.backgroundColorHandler = { [weak self] mainColor in
                guard let me = self else { return }
                me.mainColorHandler?(mainColor)
            }
            cell.configureCell(userName: name, imageRef: reference)
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MiddleProfileCell", for: indexPath) as! MiddleProfileTableViewCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FooterProfileCell", for: indexPath) as! FooterProfileTableViewCell
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SignOutCell", for: indexPath) as! SignOutTableViewCell
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension SettingsDataSource: UITableViewDelegate {

    // MARK: - Delegate

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 350
        case 1:
            return 80
        case 2:
            return 80
        default:
            return 100
        }
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        switch indexPath.section {
        case 1:
            accountTappedHandler?()
        case 2:
            aboutTappedHandler?()
        default: break
        }
    }
}

extension SettingsDataSource: SignOutTableViewCellDelegate {
    func signOutButtonPressed() {
        signOutHandler?()
    }
}

extension SettingsDataSource: ProfileTableViewCellDelegate {
    func editProfilePressed() {
        editProfileHandler?()
    }
}
