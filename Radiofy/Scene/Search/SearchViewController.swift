//
//  SearchViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 01/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import Combine
import Reusable

final class SearchViewController: RadiofyViewController<SearchModule.ViewModel> {

    private lazy var searchCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        layout.minimumLineSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(cellType: SearchCell.self)
        collectionView.register(supplementaryViewType: SearchBarReusableView.self,
                                ofKind: UICollectionView.elementKindSectionHeader)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private var stations: [RadioStation] = []
    private var searchStations: [RadioStation] = []
    private var disposeBag = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupConstraints()
        configureCollectionView()
        setupViewModel()
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
        updateSearch(searchText: searchText)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
        if searchText.isEmpty {
            updateSearch(searchText: searchText)
        }
    }
}

private extension SearchViewController {
    func configureCollectionView() {
        if let flowLayout = searchCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
          flowLayout.headerReferenceSize = CGSize(width: searchCollectionView.bounds.size.width, height: 60)
        }
    }

    func setupViewModel() {
        viewModel
            .updateAllStationsSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] allStations in
                guard let self = self else { return }
                self.stations = allStations
                self.searchStations = allStations
                self.searchCollectionView.reloadData()
            }
            .store(in: &disposeBag)

        viewModel.getAllRadioStations()
    }

    func updateSearch(searchText: String) {
        stations.removeAll()

        for item in searchStations {
            if item.name.lowercased().contains(searchText.lowercased()) {
                stations.append(item)
            }
        }

        if searchText.isEmpty {
            stations = searchStations
        }
        searchCollectionView.reloadData()
    }
}

    // MARK: - UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return stations.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let station = stations[indexPath.item]
        let cell = collectionView.dequeueReusableCell(for: indexPath) as SearchCell
        cell.configureCell(station: station, indexPath: indexPath)
        return cell
    }

   func collectionView(_ collectionView: UICollectionView,
                       viewForSupplementaryElementOfKind kind: String,
                       at indexPath: IndexPath) -> UICollectionReusableView {
       let searchView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath) as SearchBarReusableView
       searchView.searchBar.delegate = self
       searchView.configureSearchBar()
       return searchView
   }
}

    // MARK: - UICollectionViewDelegateFlowLayout

extension SearchViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let oneItem = width - 30
        if stations.count == 1 {
            return CGSize(width: oneItem, height: 100)
        } else {
            let twoItem = width - 45
            return CGSize(width: twoItem / 2, height: 100)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < stations.count else { return }
        viewModel.showSelectedRadioPage(with: stations[indexPath.item])
    }
}

private extension SearchViewController {
    func configureNavbar() {
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.standardAppearance?.backgroundColor = Asset.navBar.color
        navigationItem.scrollEdgeAppearance?.backgroundColor = Asset.navBar.color
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.prefersLargeTitles = true
        navigationItem.title = L10n.search
    }

    func setupInterface() {
        view.backgroundColor = Asset.backgroundColor.color
        view.addSubview(searchCollectionView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// Swift < 4.2 support
#if !(swift(>=4.2))
private extension UICollectionView {
  static let elementKindSectionHeader = UICollectionElementKindSectionHeader
}
#endif
