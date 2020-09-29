//
//  HomeHeaderCell.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 12/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

protocol HomeHeaderCellDelegate: class {
    func radioViewTapped(index: Int)
}

class HomeHeaderCell: UITableViewCell {

    weak var delegate: HomeHeaderCellDelegate?

    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet var cellImageView: [MorningHomeCellImageView]!
    @IBOutlet var cellLabel: [UILabel]!

    override func awakeFromNib() {
        super.awakeFromNib()
        greeting()
    }

    @IBAction func radioViewTapped(_ sender: UIView) {
        guard let accessibilityID = sender.accessibilityIdentifier else { return }
        switch accessibilityID {
        case "headerView1":
            delegate?.radioViewTapped(index: 0)
        case "headerView2":
            delegate?.radioViewTapped(index: 1)
        case "headerView3":
            delegate?.radioViewTapped(index: 2)
        case "headerView4":
            delegate?.radioViewTapped(index: 3)
        case "headerView5":
            delegate?.radioViewTapped(index: 4)
        case "headerView6":
            delegate?.radioViewTapped(index: 5)
        default: break
        }
    }
}

private extension HomeHeaderCell {
    func greeting() {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12:
            greetingLabel.text = L1s.goodMorning
        case 12..<17:
            greetingLabel.text = L1s.goodAfternoon
        case 17..<22:
            greetingLabel.text = L1s.goodEvening
        default:
            greetingLabel.text = L1s.goodNight
        }
    }
}

extension HomeHeaderCell {
    func configureCell(_ stations: [RadioStation]) {

        if stations.count == 6 {
            for index in 0...5 {
                let url = URL(string: stations[index].imageURL)
                cellImageView[index].sd_setImage(with: url, completed: nil)
                cellLabel[index].text = stations[index].name
            }
        }
    }
}
