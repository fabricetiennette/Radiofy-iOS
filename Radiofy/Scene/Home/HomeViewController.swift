//
//  HomeViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 02/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import Combine

class HomeViewController: UIViewController, Storyboarded {

    #warning("to put on same level as the bonjour label, in same cell")
    @IBOutlet private weak var settingButton: SettingButtonView!
    @IBOutlet private weak var homeTableView: UITableView!

    private lazy var homeDataSource = HomeDataSource()
    private var disposeBag = Set<AnyCancellable>()
    var viewModel: HomeModule.ViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.delegate = homeDataSource
        homeTableView.dataSource = homeDataSource

        setupBindings()
        bindViewModel(to: homeDataSource)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        configureViewModel()
    }

    @IBAction private func settingsButtonTapped(_ sender: Any) {
        viewModel?.launchSettingsPage()
    }
}

private extension HomeViewController {

    func setupBindings() {
        guard let viewModel = self.viewModel else { return }

        viewModel
            .errorPublisher
            .sink { [weak self] title, message in
                guard let self = self else { return }
                self.showAlert(title: title, message: message)
            }
            .store(in: &disposeBag)

        viewModel
            .headerPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] radioStations in
                guard let self = self else { return }
                self.homeDataSource.updateHeaderCell(headerStations: radioStations)
                self.homeTableView.reloadData()
            }
            .store(in: &disposeBag)

        viewModel
            .recentlyPlayedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] radioStations in
                guard let self = self else { return }
                self.homeDataSource.updateRecentlyPlayedCell(recentlyPlayedStations: radioStations)
                self.homeTableView.reloadData()
            }
            .store(in: &disposeBag)

        viewModel
            .popularPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] radioStations in
                guard let self = self else { return }
                self.homeDataSource.updatePopularStationsCell(popularStations: radioStations)
                self.homeTableView.reloadData()
            }
            .store(in: &disposeBag)

        viewModel
            .nationalPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] radioStations in
                guard let self = self else { return }
                self.homeDataSource.updateNationalStationsCell(nationalStations: radioStations)
                self.homeTableView.reloadData()
            }
            .store(in: &disposeBag)

        viewModel.verifiedAndFetchRadioStations()
    }

    func bindViewModel(to dataSource: HomeDataSource) {
        dataSource
            .settingButtonPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alpha in
                guard let self = self else { return }
                self.settingButton.alpha = alpha
            }
            .store(in: &disposeBag)

        dataSource
            .radioTappedPublisher
            .sink { [weak self] radioSelected in
                guard let self = self else { return }
                self.viewModel?.showSelectedRadioPage(with: radioSelected)
            }
            .store(in: &disposeBag)
    }

    func configureViewModel() {
        viewModel?.getRecentlyPlayedStationsDetails()
    }
}
