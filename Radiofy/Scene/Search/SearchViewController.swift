//
//  SearchViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 01/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet private weak var searchCollectionView: UICollectionView!

    private lazy var searchDataSource = SearchDataSource()
    var viewModel: SearchViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchCollectionView.dataSource = searchDataSource
        searchCollectionView.delegate = searchDataSource

        bind(to: viewModel)
        bindViewModel(to: searchDataSource)

        configureNavbar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavbar()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        searchDataSource.updateSearch(searchText: searchText)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
        if searchText.isEmpty {
            searchDataSource.updateSearch(searchText: searchText)
        }
    }
}

private extension SearchViewController {

    func bind(to viewModel: SearchViewModel) {
        viewModel.updateAllStationsHandler = { [weak self] allStations in
            guard let me = self else { return }
            DispatchQueue.main.async {
                me.searchDataSource.updateCell(stations: allStations)
                me.searchCollectionView.reloadData()
            }
        }
        viewModel.getAllRadioStations()
    }

    func bindViewModel(to dataSource: SearchDataSource) {
        dataSource.radioSelectedHandler = { [weak self] radioSelected in
            guard let me = self else { return }
            me.viewModel.showSelectedRadioPage(with: radioSelected)
        }
        dataSource.reloadHandler = { [weak self] in
            guard let me = self else { return }
            me.searchCollectionView.reloadData()
        }
        searchCollectionView.keyboardDismissMode = .onDrag
    }
}

private extension SearchViewController {

    func configureNavbar() {
        guard let navigationController = navigationController else { return }
        if #available(iOS 13.0, *) {
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
            navigationItem.title = L1s.searchTitle
        } else {
            navigationController.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationController.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.isTranslucent = true
            navigationController.navigationBar.tintColor = .white
            navigationController.navigationBar.prefersLargeTitles = true
            navigationItem.title = L1s.searchTitle
        }
    }
}

extension SearchViewController: Storyboarded {}
