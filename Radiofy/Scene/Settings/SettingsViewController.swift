//
//  SettingsViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 01/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import Combine

class SettingsViewController: UIViewController, Storyboarded {

    @IBOutlet private weak var settingsTableView: UITableView!
    @IBOutlet private weak var magicBackgrounView: UIView!

    var viewModel: SettingsModule.ViewModel?

    private lazy var settingsDataSource = SettingsDataSource()
    private var disposedBag = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView.delegate = settingsDataSource
        settingsTableView.dataSource = settingsDataSource

        setupBindings()
        bindViewModel(to: settingsDataSource)
        viewModel?.getUserProfilePhotoReference()
        configureView()
        viewModel?.getUserName()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        configureView()
        viewModel?.isUserLoggedIn()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.removeListener()
    }
}

private extension SettingsViewController {

    func bindViewModel(to dataSource: SettingsDataSource) {
        dataSource.signOutHandler = { [weak self] in
            guard let me = self else { return }
            me.showAlertAndConfirmLogOut {
                me.viewModel?.signOutUser()
            }
        }
        dataSource.editProfileHandler = { [weak self] in
            guard let me = self else { return }
            me.viewModel?.showOrCreateProfileView()
        }
        dataSource.accountTappedHandler = { [weak self] in
            guard let me = self else { return }
            me.viewModel?.showAccountView()
        }
        dataSource.aboutTappedHandler = { [weak self] in
            guard let me = self else { return }
            me.viewModel?.showAboutView()
        }
        dataSource.mainColorHandler = { [weak self] mainColor in
            guard let me = self else { return }
            me.magicBackgrounView.setBackgourndColorWithGradient(
                colorHead: mainColor,
                colorCenter: ColorName.darkSlateColor.color,
                colorBottom: ColorName.darkSlateColor.color
            )
        }
    }

    func setupBindings() {
        guard let viewModel = self.viewModel else { return }

        viewModel
            .errorSubject
            .sink { [weak self] title, message in
                guard let self = self else { return }
                self.showAlert(title: title, message: message)
            }
            .store(in: &disposedBag)

        viewModel
            .refSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] reference in
                guard let self = self else { return }
                self.settingsDataSource.updateCellPhoto(reference)
                self.settingsTableView.reloadData()
            }
            .store(in: &disposedBag)

        viewModel
            .userNameSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] name in
                guard let self = self else { return }
                self.settingsDataSource.updateCellUserName(name)
                self.settingsTableView.reloadData()
            }
            .store(in: &disposedBag)
    }

    func configureView() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor(cgColor: #colorLiteral(red: 0.156845212, green: 0.1568739116, blue: 0.1568388939, alpha: 1))
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.title = L10n.settings
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            image: .none,
            style: .plain,
            target: nil,
            action: nil
        )
    }
}
