// swiftlint:disable force_cast
//
//  SearchDataSource.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 17/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class SearchDataSource: NSObject, UICollectionViewDataSource {

    var radioSelectedHandler: ((_ radio: RadioStation) -> Void)?
    var reloadHandler: (() -> Void)?

    private var stations: [RadioStation] = []
    private var searchStations: [RadioStation] = []

    func updateCell(stations: [RadioStation]) {
        self.stations = stations
        self.searchStations = stations
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
        reloadHandler?()
    }

    // MARK: - DataSource

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return stations.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let station = stations[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
        cell.configureCell(station: station, indexPath: indexPath)
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {

        let searchView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader ,
            withReuseIdentifier: "SearchBarCell",
            for: indexPath
        ) as! SearchBarReusableView
        searchView.configureSearchBar()
        return searchView
    }
}

extension SearchDataSource: UICollectionViewDelegateFlowLayout {

    // MARK: - Delegate

    func collectionView(
           _ collectionView: UICollectionView,
           layout collectionViewLayout: UICollectionViewLayout,
           sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = UIScreen.main.bounds.width
        let oneItem = width - 30
        if stations.count == 1 {
            return CGSize(width: oneItem, height: 100)
        } else {
            let twoItem = width - 45
            return CGSize(width: twoItem / 2, height: 100)
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard indexPath.item < stations.count else { return }
        radioSelectedHandler?(stations[indexPath.item])
    }
}
