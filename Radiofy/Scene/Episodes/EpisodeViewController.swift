//
//  EpisodeViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 30/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class EpisodeViewController: UIViewController {

    @IBOutlet weak var episodeTableView: UITableView!

    private lazy var episodeDataSource = EpisodeDataSource()
    private let indicator = LoaderIndicator.shared
    var viewModel: EpisodeViewModel!
    private var episode: Episode!

    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.show(indicator: view)
        episodeTableView.delegate = episodeDataSource
        episodeTableView.dataSource = episodeDataSource

        configureNavbar()

        bind(to: viewModel)
        bindViewModel(to: episodeDataSource)
    }
}

private extension EpisodeViewController {

    func bind(to viewModel: EpisodeViewModel) {
        viewModel.errorHandler = { [weak self] title, message in
            guard let me = self else { return }
            me.indicator.hide()
            me.showAlert(title: title, message: message)
        }
        viewModel.episodeHandler = { [weak self] allEpisode in
            guard let me = self else { return }
            DispatchQueue.main.async {
                me.episodeDataSource.updateCell(with: allEpisode)
                me.episodeTableView.reloadData()
                me.indicator.hide()
            }
        }
        viewModel.getEpisode()
    }

    func bindViewModel(to dataSource: EpisodeDataSource) {
        dataSource.episodeTapHandler = { [weak self] episode in
            guard let me = self else { return }
            me.episode = episode
            me.viewModel.getAndPlayEpisode(with: episode)
        }
    }
}

private extension EpisodeViewController {

    func configureNavbar() {
//        guard let navigationController = navigationController else { return }
//        navigationController.navigationBar.titleTextAttributes = [
//            NSAttributedString.Key.foregroundColor: UIColor.white]
//        navigationItem.standardAppearance?.backgroundColor = Asset.navBar.color
//        navigationItem.scrollEdgeAppearance?.backgroundColor = Asset.navBar.color
//        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController.navigationBar.isTranslucent = true
//        navigationController.navigationBar.tintColor = .white
//        navigationItem.largeTitleDisplayMode = .never
//        navigationItem.title = viewModel.selectedPodcast?.trackName
    }
}

extension EpisodeViewController: Storyboarded {}
