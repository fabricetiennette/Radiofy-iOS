//
//  HomeViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 02/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet private weak var settingButton: SettingButtonView!
    @IBOutlet private weak var homeTableView: UITableView!

    private lazy var homeDataSource = HomeDataSource()
    var viewModel: HomeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.delegate = homeDataSource
        homeTableView.dataSource = homeDataSource

        bind(to: viewModel)
        bindViewModel(to: homeDataSource)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        configureViewModel()
    }

    @IBAction private func settingsButtonTapped(_ sender: Any) {
        viewModel.launchSettingsPage()
    }
}

extension HomeViewController: Storyboarded {}

private extension HomeViewController {

    func bind(to viewModel: HomeViewModel) {
        viewModel.errorHandler = { [weak self] title, message in
            guard let me = self else { return }
            me.showAlert(title: title, message: message)
        }
        viewModel.headerRadioHandler = { [weak self] radioStations in
            guard let me = self else { return }
            DispatchQueue.main.async {
                me.homeDataSource.updateHeaderCell(headerStations: radioStations)
                me.homeTableView.reloadData()
            }
        }
        viewModel.recentlyPlayedRadioHandler = { [weak self] radioStations in
            guard let me = self else { return }
            DispatchQueue.main.async {
                me.homeDataSource.updateRecentlyPlayedCell(
                    recentlyPlayedStations: radioStations
                )
                me.homeTableView.reloadData()
            }
        }
        viewModel.popularRadioHandler = { [weak self] radioStations in
            guard let me = self else { return }
            DispatchQueue.main.async {
                me.homeDataSource.updatePopularStationsCell(
                    popularStations: radioStations
                )
                me.homeTableView.reloadData()
            }
        }
        viewModel.nationalRadioHandler = { [weak self] radioStations in
            guard let me = self else { return }
            DispatchQueue.main.async {
                me.homeDataSource.updateNationalStationsCell(
                    nationalStations: radioStations
                )
                me.homeTableView.reloadData()
            }
        }
        viewModel.verifiedAndFetchRadioStations()
    }

    func bindViewModel(to dataSource: HomeDataSource) {
        dataSource.settingButtonHandler = { [weak self] alpha in
            guard let me = self else { return }
            DispatchQueue.main.async {
                me.settingButton.alpha = alpha
            }
        }
        dataSource.radioTappedHandler = { [weak self] radioSelected in
            guard let me = self else { return }
            me.viewModel.showSelectedRadioPage(with: radioSelected)
        }
    }

    func configureViewModel() {
        viewModel.getRecentlyPlayedStationsDetails()
    }
}
