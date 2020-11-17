//
//  EpisodeViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 30/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class EpisodeViewController: UIViewController {

    @IBOutlet weak var episodeTableView: UITableView!

    private lazy var episodeDataSource = EpisodeDataSource()
    var viewModel: EpisodeViewModel!
    private var episode: Episode!

    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
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
            me.stopAnimating()
            me.showAlert(title: title, message: message)
        }
        viewModel.episodeHandler = { [weak self] allEpisode in
            guard let me = self else { return }
            DispatchQueue.main.async {
                me.episodeDataSource.updateCell(with: allEpisode)
                me.episodeTableView.reloadData()
                me.stopAnimating()
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

    func startAnimation() {
        let size = CGSize(width: 50, height: 50)
        startAnimating(size, type: .ballBeat, color: .white, fadeInAnimation: nil)
    }

    func configureNavbar() {
        guard let navigationController = navigationController else { return }
        if #available(iOS 13.0, *) {
            navigationController.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationItem.standardAppearance?.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.09807916731, green: 0.09796635062, blue: 0.1023270264, alpha: 1))
            navigationItem.scrollEdgeAppearance?.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.09807916731, green: 0.09796635062, blue: 0.1023270264, alpha: 1))
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.isTranslucent = true
            navigationController.navigationBar.tintColor = .white
            navigationItem.largeTitleDisplayMode = .never
            navigationItem.title = viewModel.selectedPodcast?.trackName
        } else {
            navigationController.navigationBar.titleTextAttributes = [
                           NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.isTranslucent = true
            navigationController.navigationBar.tintColor = .white
            navigationItem.largeTitleDisplayMode = .never
            navigationItem.title = viewModel.selectedPodcast?.trackName
        }
    }
}

extension EpisodeViewController: Storyboarded, NVActivityIndicatorViewable {}
