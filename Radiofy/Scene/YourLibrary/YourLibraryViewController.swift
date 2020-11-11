//
//  YourLibraryViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 01/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class YourLibraryViewController: UIViewController {

    @IBOutlet private weak var libraryTableView: UITableView!

    private lazy var yourLibraryDataSource = YourLibraryDataSource()

    var viewModel: YourLibraryViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        libraryTableView.delegate = yourLibraryDataSource
        libraryTableView.dataSource = yourLibraryDataSource

        bind(to: viewModel)
        bindViewModel(to: yourLibraryDataSource)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
        viewModel.getFavoritesRadioStations()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }
}

private extension YourLibraryViewController {

    func bind(to viewModel: YourLibraryViewModel) {
        viewModel.favoriteStationsHandler = { [weak self] favoriteRadioStations in
            guard let me = self else { return }
            DispatchQueue.main.async {
                me.yourLibraryDataSource.updateCell(with: favoriteRadioStations)
                me.libraryTableView.reloadData()
            }
        }
        viewModel.messageHandler = { text in
            self.emtpyMessage(text)
        }
        viewModel.getFavoritesRadioStations()
    }

    func bindViewModel(to dataSource: YourLibraryDataSource) {
        dataSource.didTapFavoriteHandler = { [weak self] radioSelected in
             guard let me = self else { return }
            me.viewModel.showSelectedRadioPage(with: radioSelected)
        }
    }

    func emtpyMessage(_ text: String) {
        if viewModel.favorite.isEmpty {
            libraryTableView.setEmptyMessage(text)
        } else {
            libraryTableView.restore()
        }
    }
}

private extension YourLibraryViewController {

    func configureNavBar() {
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.backItem?.title = " "
        navigationItem.title = "Radio"
    }
}

extension YourLibraryViewController: Storyboarded {}
