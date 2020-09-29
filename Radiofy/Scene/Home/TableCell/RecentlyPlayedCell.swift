//swiftlint:disable force_cast
//
//  RecentlyPlayedCell.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 08/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class RecentlyPlayedCell: UITableViewCell {

    @IBOutlet weak var recentlyPlayedLabel: UILabel!
    @IBOutlet weak var recentlyPlayedCollectionView: UICollectionView!
    @IBOutlet weak var welcomeView: UIView!

    private var stations: [RadioStation] = []
    var selectedRadioHandler: ((RadioStation) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        recentlyPlayedCollectionView.delegate = self
        recentlyPlayedCollectionView.dataSource = self
    }

    func configureCell(_ stations: [RadioStation]) {
        self.stations = stations
        isRecentlyPlayedStationsAvailable()
    }
}

private extension RecentlyPlayedCell {

    func isRecentlyPlayedStationsAvailable() {
        if stations.isEmpty {
            recentlyPlayedLabel.isHidden = true
            welcomeView.isHidden = false
        } else {
            recentlyPlayedLabel.isHidden = false
            welcomeView.isHidden = true
        }
    }
}

extension RecentlyPlayedCell: UICollectionViewDataSource {

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
        let station = stations[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RplayedCell", for: indexPath) as! RecentlyPlayedCollectionViewCell
        cell.configureCell(station: station)
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard indexPath.row < stations.count else { return }
        selectedRadioHandler?(stations[indexPath.row])
    }
}

extension RecentlyPlayedCell: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 130, height: 150)
    }
}
