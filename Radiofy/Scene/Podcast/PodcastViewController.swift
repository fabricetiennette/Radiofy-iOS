//
//  PodcastViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 30/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class PodcastViewController: UIViewController {

    @IBOutlet weak var podcastTableView: UITableView!

    private lazy var podcastDataSource = PodcastDataSource()
    var viewModel: PodcastViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        podcastTableView.delegate = podcastDataSource
        podcastTableView.dataSource = podcastDataSource

        bind(to: viewModel)
        bindViewModel(to: podcastDataSource)

        configureNavbar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavbar()
    }
}

private extension PodcastViewController {
    func bind(to viewModel: PodcastViewModel) {
        viewModel.allPodcastStationsHandler = { [weak self] podcastStations in
            guard let me = self else { return }
            DispatchQueue.main.async {
                me.podcastDataSource.updateCell(with: podcastStations)
                me.podcastTableView.reloadData()
            }
        }
        viewModel.verifiedAndFetchPodcastStations()
    }

    func bindViewModel(to dataSource: PodcastDataSource) {
        dataSource.didTapPodcastStationHandler = { [weak self] podcastStation in
            guard let me = self else { return }
            me.viewModel.showSelectedPodcastStation(with: podcastStation)
        }
    }
}

private extension PodcastViewController {
    func configureNavbar() {
//        guard let navigationController = navigationController else { return }
//            navigationController.navigationBar.titleTextAttributes = [
//                NSAttributedString.Key.foregroundColor: UIColor.white]
//            navigationController.navigationBar.largeTitleTextAttributes = [
//                NSAttributedString.Key.foregroundColor: UIColor.white]
//            navigationItem.standardAppearance?.backgroundColor = Asset.navBar.color
//            navigationItem.scrollEdgeAppearance?.backgroundColor = Asset.navBar.color
//            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
//            navigationController.navigationBar.shadowImage = UIImage()
//            navigationController.navigationBar.isTranslucent = true
//            navigationController.navigationBar.tintColor = .white
//            navigationController.navigationBar.prefersLargeTitles = true
//            navigationItem.title = "Podcast"
    }
}

extension PodcastViewController: Storyboarded {}
