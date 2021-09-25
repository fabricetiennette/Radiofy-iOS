//
//  PodcastListViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 30/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class PodcastListViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!

    private lazy var podcastListDataSource = PodcastListDataSource()
    var viewModel: PodcastListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = podcastListDataSource
        listTableView.dataSource = podcastListDataSource

        bind(to: viewModel)
        bindViewModel(to: podcastListDataSource)

        configureNavbar()
    }
}

private extension PodcastListViewController {

    func bind(to viewModel: PodcastListViewModel) {
        viewModel.errorHandler = { [weak self] title, message in
            guard let me = self else { return }
            me.showAlert(title: title, message: message)
        }
        viewModel.podcastServiceHandler = { [weak self] podcasts in
            guard let me = self else { return }
            DispatchQueue.main.async {
                me.podcastListDataSource.updateCell(with: podcasts)
                me.listTableView.reloadData()
            }
        }
    }

    func bindViewModel(to dataSource: PodcastListDataSource) {
        dataSource.podcastTapHandle = { [weak self] podcastSelected in
            guard let me = self else { return }
            me.viewModel.showEpisodeView(with: podcastSelected)
        }
    }
}
private extension PodcastListViewController {
    func configureNavbar() {
        guard let navigationController = navigationController else { return }
            navigationController.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationController.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationItem.standardAppearance?.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.09807916731, green: 0.09796635062, blue: 0.1023270264, alpha: 1))
            navigationItem.scrollEdgeAppearance?.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.09807916731, green: 0.09796635062, blue: 0.1023270264, alpha: 1))
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.isTranslucent = true
            navigationController.navigationBar.tintColor = .white
            navigationController.navigationBar.prefersLargeTitles = true
            navigationItem.title = viewModel.title
    }
}
extension PodcastListViewController: Storyboarded {}
