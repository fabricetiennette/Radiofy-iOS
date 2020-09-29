//swiftlint:disable force_cast
//
//  HomeDataSource.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 08/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class HomeDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {

    private var headerStations: [RadioStation] = []
    private var recentlyPlayedStations: [RadioStation] = []
    private var popularStations: [RadioStation] = []
    private var nationalStations: [RadioStation] = []

    var radioTappedHandler: ((RadioStation) -> Void)?
    var settingButtonHandler: ((_ alpha: CGFloat) -> Void)?

    func updateHeaderCell(headerStations: [RadioStation]) {
        self.headerStations = headerStations
    }

    func updateRecentlyPlayedCell(recentlyPlayedStations: [RadioStation]) {
        self.recentlyPlayedStations = recentlyPlayedStations
    }

    func updatePopularStationsCell(popularStations: [RadioStation]) {
        self.popularStations = popularStations
    }

    func updateNationalStationsCell(nationalStations: [RadioStation]) {
        self.nationalStations = nationalStations
    }

    // Number of row in one section
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 1
    }

    // Set the spacing between sections
     func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
     ) -> CGFloat {
         return 15
     }

     // Make the header background color .clear
     func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
     ) -> UIView? {
         let headerView = UIView()
         headerView.backgroundColor = .clear
         return headerView
     }

    // Number of section in tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    // Height of row
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 300
        case 1:
            return 220
        case 2:
            return 220
        case 3:
            return 220
        default: return 0
        }
    }

    // Cell for indexpath
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        tableView.accessibilityIdentifier = "HomeTableView"
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeHeaderCell", for: indexPath) as! HomeHeaderCell
            cell.configureCell(headerStations)
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "recentlyPlayedCell", for: indexPath) as! RecentlyPlayedCell
            cell.configureCell(recentlyPlayedStations)
            cell.recentlyPlayedCollectionView.reloadData()
            cell.selectedRadioHandler = { [weak self] radioSelected in
                guard let me = self else { return }
                me.radioTappedHandler?(radioSelected)
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "popularStationsCell", for: indexPath) as! PopularStationsCell
            cell.configureCell(popularStations)
            cell.popularSCollectionView.reloadData()
            cell.selectedRadioHandler = { [weak self] radioSelected in
                guard let me = self else { return }
                me.radioTappedHandler?(radioSelected)
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "nationalStationsCell", for: indexPath) as! NationalStationsCell
            cell.configureCell(nationalStations)
            cell.nationalStationsCollectionView.reloadData()
            cell.selectedRadioHandler = { [weak self] radioSelected in
                guard let me = self else { return }
                me.radioTappedHandler?(radioSelected)
            }
            return cell
        default: return UITableViewCell()
        }
    }

    // fade setting button when scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 1 {
            settingButtonHandler?(0)
        } else {
            settingButtonHandler?(1)
        }
    }
}

extension HomeDataSource: HomeHeaderCellDelegate {
    func radioViewTapped(index: Int) {
        guard index < headerStations.count else { return }
        radioTappedHandler?(headerStations[index])
    }
}
