//swiftlint:disable force_cast
//
//  NationalStationsCell.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 08/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class NationalStationsCell: UITableViewCell {

    @IBOutlet weak var nationalStationsCollectionView: UICollectionView!

    private var stations: [RadioStation] = []
    var selectedRadioHandler: ((RadioStation) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        nationalStationsCollectionView.delegate = self
        nationalStationsCollectionView.dataSource = self
    }

    func configureCell(_ stations: [RadioStation]) {
        self.stations = stations
    }
}

extension NationalStationsCell: UICollectionViewDataSource {

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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NStationsCell", for: indexPath) as! NationalStationsCollectionViewCell
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

extension NationalStationsCell: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 130, height: 150)
    }
}
