//
//  YourLibraryViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 01/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import Combine

final class YourLibraryViewController: RadiofyViewController<YourLibraryModule.ViewModel> {

    @IBOutlet private weak var libraryTableView: UITableView!

    private lazy var yourLibraryDataSource = YourLibraryDataSource()
    private var disposeBag: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        libraryTableView.delegate = yourLibraryDataSource
        libraryTableView.dataSource = yourLibraryDataSource

        configureViewModel()
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

    func configureViewModel() {
        viewModel
            .favoriteStationsSubject
            .sink(receiveValue: { [weak self] favoriteRadioStations in
                guard let self = self else { return }
                self.yourLibraryDataSource.updateCell(with: favoriteRadioStations)
                self.libraryTableView.reloadData()
            })
            .store(in: &disposeBag)

        viewModel
            .messageSubject
            .sink(receiveValue: { [weak self] text in
                guard let self = self else { return }
                self.emtpyMessage(text)
            })
            .store(in: &disposeBag)

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
