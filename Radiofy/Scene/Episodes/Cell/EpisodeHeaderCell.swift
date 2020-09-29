//
//  EpisodeHeaderCell.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 30/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import FirebaseUI

class EpisodeHeaderCell: UITableViewCell {

    @IBOutlet weak var imageViewPodcast: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var decriptionTextView: UITextView!

    func configureCell(episode: Episode?) {

        guard let text = episode?.mainDescription,
            let url = episode?.imageUrl,
            let title = episode?.mainTitle,
            let author = episode?.author
            else { return }

        decriptionTextView.text = text
        mainTitleLabel.text = title
        authorLabel.text = author
        imageViewPodcast.sd_setImage(with: URL(string: url), completed: nil)
    }
}
