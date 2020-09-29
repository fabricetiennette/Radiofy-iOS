//
//  MiniPlayerViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 10/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import LNPopupController

enum PlayMode {
    case playing
    case notPlaying
}

class MiniPlayerViewController: LNPopupCustomBarViewController {

    @IBOutlet weak var barImageView: UIImageView!
    @IBOutlet weak var barTitleLabel: UILabel!
    @IBOutlet weak var barConnectionLabel: UILabel!
    @IBOutlet weak var magiciAnimationView: UIView!
    @IBOutlet weak var playAndStopButton: UIButton!

    var viewModel: MiniPlayerViewModel!
    private var playState: PlayMode!

    override var wantsDefaultPanGestureRecognizer: Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        playState = .notPlaying
        preferredContentSize = CGSize(width: 0, height: 0)
    }

    override func popupItemDidUpdate() {
        guard let progress = containingPopupBar.popupItem?.progress else { return }

        barTitleLabel.text = containingPopupBar.popupItem?.title
        barImageView.image = containingPopupBar.popupItem?.image
        barConnectionLabel.text = containingPopupBar.popupItem?.subtitle

        if containingPopupBar.popupItem?.subtitle == L1s.loadingTitle {
            preferredContentSize = CGSize(width: -1, height: 52)
        }

        if progress == 1.0 {
            playState = .playing
        }

        if progress == 0.0 {
            playState = .notPlaying
        }

        switch playState {
        case .notPlaying:
            playAndStopButton.isSelected = false
        case .playing:
            playAndStopButton.isSelected = true
        default: break
        }
    }
}

extension MiniPlayerViewController {

    @IBAction func didTapPlayButton(_ sender: Any) {
        configureButtonState()
        switch playState {
        case .notPlaying:
            viewModel.stop()
        case .playing:
            viewModel.play()
        default: break
        }
    }
}

extension MiniPlayerViewController: Storyboarded {}

private extension MiniPlayerViewController {

    func configureButtonState() {
        playAndStopButton.isSelected = (playAndStopButton.isSelected == false) ? true : false
        if playAndStopButton.isSelected {
            playState = .playing
        } else {
            playState = .notPlaying
        }
    }
}
