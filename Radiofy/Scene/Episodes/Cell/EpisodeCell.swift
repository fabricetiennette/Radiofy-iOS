//
//  EpisodeCell.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 30/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    func configureCell(episode: Episode, indexPath: IndexPath) {
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "dd MMM YYYY"
        let date = dateTimeFormatter.string(from: episode.pubDate)
        dateLabel.text = date
        titleLabel.text = episode.title
        guard let duration = episode.duration else { return }

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated

        let formattedString = formatter.string(from: duration) ?? "n/a"

        durationLabel.text = "\(L1s.duration): \(formattedString)"
    }
}
