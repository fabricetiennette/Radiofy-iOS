//
//  YourLibraryViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 01/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import Combine
import Reusable

final class YourLibraryViewController: RadiofyViewController<YourLibraryModule.ViewModel> {

    private lazy var libraryTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(cellType: FavoriteRadioCell.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var disposeBag: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupConstraints()
        configureViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
        viewModel.getFavoritesRadioStations()
        libraryTableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }
}

private extension YourLibraryViewController {

    func configureViewModel() {
        viewModel
            .messageSubject
            .sink(receiveValue: { [weak self] text in
                guard let self = self else { return }
                self.emtpyMessage(text)
            })
            .store(in: &disposeBag)

        viewModel.getFavoritesRadioStations()
    }

    func emtpyMessage(_ text: String) {
        if viewModel.favorite.isEmpty {
            libraryTableView.setEmptyMessage(text)
        } else {
            libraryTableView.restore()
        }
    }
}

extension YourLibraryViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - DataSource

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.favorite.count
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           viewModel.favorite[indexPath.row]
        }
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.accessibilityIdentifier = "favListId"
        let station = viewModel.favorite[indexPath.row]
        let cell = tableView.dequeueReusableCell(for: indexPath) as FavoriteRadioCell
        cell.accessibilityIdentifier = "favoriteRadioCell_\(indexPath.row)"
        cell.configureCell(station: station, indexPath: indexPath)
        return cell
    }

    // MARK: - Delegate

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.favorite.count else { return }
        viewModel.showSelectedRadioPage(with: viewModel.favorite[indexPath.row])
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

    func setupInterface() {
        view.backgroundColor = Asset.backgroundColor.color
        view.addSubview(libraryTableView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            libraryTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            libraryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            libraryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            libraryTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
