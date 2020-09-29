//
//  SettingsViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 01/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, Storyboarded {

    @IBOutlet private weak var settingsTableView: UITableView!
    @IBOutlet private weak var magicBackgrounView: UIView!

    var viewModel: SettingsViewModel!

    private lazy var settingsDataSource = SettingsDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView.delegate = settingsDataSource
        settingsTableView.dataSource = settingsDataSource

        bind(to: viewModel)
        bindViewModel(to: settingsDataSource)
        viewModel.getUserProfilePhotoReference()
        configureView()
        viewModel.getUserName()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        configureView()
        viewModel.isUserLoggedIn()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.removeListener()
    }
}

private extension SettingsViewController {

    func bindViewModel(to dataSource: SettingsDataSource) {
        dataSource.signOutHandler = { [weak self] in
            guard let me = self else { return }
            me.showAlertAndConfirmLogOut {
                me.viewModel.signOutUser()
            }
        }
        dataSource.editProfileHandler = { [weak self] in
            guard let me = self else { return }
            me.viewModel.showOrCreateProfileView()
        }
        dataSource.accountTappedHandler = { [weak self] in
            guard let me = self else { return }
            me.viewModel.showAccountView()
        }
        dataSource.aboutTappedHandler = { [weak self] in
            guard let me = self else { return }
            me.viewModel.showAboutView()
        }
        dataSource.mainColorHandler = { [weak self] mainColor in
            guard let me = self else { return }
            me.magicBackgrounView.setBackgourndColorWithGradient(
                colorHead: mainColor,
                colorCenter: #colorLiteral(red: 0.07057782263, green: 0.07059488446, blue: 0.07057409734, alpha: 1),
                colorBottom: #colorLiteral(red: 0.07057782263, green: 0.07059488446, blue: 0.07057409734, alpha: 1)
            )
        }
    }

    func bind(to viewModel: SettingsViewModel) {
        viewModel.errorHandler = { [weak self] title, message in
            guard let me = self else { return }
            me.showAlert(title: title, message: message)
        }
        viewModel.refHandler = { [weak self] reference in
            guard let me = self else { return }
            DispatchQueue.main.async {
                me.settingsDataSource.updateCellPhoto(reference)
                me.settingsTableView.reloadData()
            }
        }
        viewModel.userNameHandler = { [weak self] name in
            guard let me = self else { return }
            DispatchQueue.main.async {
                me.settingsDataSource.updateCellUserName(name)
                me.settingsTableView.reloadData()
            }
        }
    }

    func configureView() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor(cgColor: #colorLiteral(red: 0.156845212, green: 0.1568739116, blue: 0.1568388939, alpha: 1))
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.title = L1s.settings
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            image: .none,
            style: .plain,
            target: nil,
            action: nil
        )
    }
}
