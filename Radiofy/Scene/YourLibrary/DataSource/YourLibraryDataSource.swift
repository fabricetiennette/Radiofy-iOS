// swiftlint:disable force_cast
//
//  YourLibraryDataSource.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 16/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class YourLibraryDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {

    var didTapFavoriteHandler: ((_ radioSelected: RadioStation) -> Void)?
    var deleteFavoriteHandler: ((_ radioSelected: RadioStation) -> Void)?

    private var stations: [RadioStation] = []

    func updateCell(with favoriteStation: [RadioStation]) {
        self.stations = favoriteStation
    }

    // MARK: - DataSource

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return stations.count
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            deleteFavoriteHandler?(stations[indexPath.row])
        }
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        tableView.accessibilityIdentifier = "favListId"
        let station = stations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteRadioCell", for: indexPath) as! FavoriteRadioCell
        cell.accessibilityIdentifier = "favoriteRadioCell_\(indexPath.row)"
        cell.configureCell(station: station, indexPath: indexPath)
        return cell
    }

    // MARK: - Delegate

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < stations.count else { return }
        didTapFavoriteHandler?(stations[indexPath.row])
    }
}
