//
//  MiniPlayerViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 10/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import LNPopupController
import FRadioPlayer
import Combine

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
    private var cancellables = Set<AnyCancellable>()
    
    private var playState: PlayMode = .notPlaying {
        didSet {
            guard oldValue != playState else { return }
            updatePlayButtonUI()
        }
    }
    
    override var wantsDefaultPanGestureRecognizer: Bool { false }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePreferredHeight()
        preparePlayButton()
        
        PlaybackCenter.shared.$isPodcastPlaying
            .removeDuplicates()
            .debounce(for: .milliseconds(150), scheduler: DispatchQueue.main)
            .combineLatest(PlaybackCenter.shared.$isRadioPlaying.removeDuplicates())
            .map { isPod, isRadio -> Bool in
                return (self.viewModel.audioType == .podcast) ? isPod : isRadio
            }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isPlaying in
                guard let self = self else { return }
                self.applyPlayUI(isPlaying: isPlaying) // ← on ne touche PAS isSelected
            }
            .store(in: &cancellables)
    }
    
    override func popupItemDidUpdate() {
        guard let item = containingPopupBar?.popupItem else { return }
        
        barTitleLabel.text = item.title
        barImageView.image = item.image
        barConnectionLabel.text = item.subtitle
        
        updatePreferredHeight()
    }
    
    private func updatePreferredHeight() {
        let hasContent =
        (containingPopupBar?.popupItem?.title?.isEmpty == false) ||
        (containingPopupBar?.popupItem?.image != nil) ||
        (containingPopupBar?.popupItem?.subtitle == L10n.loading)
        
        preferredContentSize = hasContent
        ? CGSize(width: -1, height: 52)
        : .zero
    }
    
    
    @IBAction func didTapPlayButton(_ sender: Any) {
        switch viewModel.audioType {
        case .radio:
            PlaybackCenter.shared.isRadioPlaying
            ? PlaybackCenter.shared.stopRadio()
            : PlaybackCenter.shared.playRadio()
            
        case .podcast:
            PlaybackCenter.shared.isPodcastPlaying
            ? PlaybackCenter.shared.pausePodcast()
            : PlaybackCenter.shared.playPodcast()
        }
    }
}

extension MiniPlayerViewController: Storyboarded {}

   // MARK: - Helpers
private extension MiniPlayerViewController {
    
    func applyPlayUI(isPlaying: Bool) {
        if #available(iOS 15.0, *) {
            let newTag = isPlaying ? 1 : 0
            guard playAndStopButton.tag != newTag else { return }
            playAndStopButton.tag = newTag
            
            UIView.performWithoutAnimation {
                playAndStopButton.setNeedsUpdateConfiguration()
                playAndStopButton.layoutIfNeeded()
            }
        } else {
            let imageName = isPlaying ? Asset.pauseButton.image : Asset.playButton.image
            UIView.performWithoutAnimation {
                self.playAndStopButton.setImage(imageName, for: .normal)
                self.playAndStopButton.layoutIfNeeded()
            }
        }
    }
    
    func preparePlayButton() {
        if #available(iOS 15.0, *) {
            var cfg = UIButton.Configuration.plain()
            cfg.contentInsets = .init(top: 6, leading: 6, bottom: 6, trailing: 6)
            playAndStopButton.configuration = cfg
            
            playAndStopButton.configurationUpdateHandler = { [weak self] btn in
                guard self != nil else { return }
                
                let isPlaying = (btn.tag == 1)
                var cfg = btn.configuration ?? .plain()
                let image = isPlaying ? Asset.pauseButton.image : Asset.playButton.image
                let resizedImage = image.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20))
                    .preparingThumbnail(of: CGSize(width: 40, height: 40)) ?? image
                
                cfg.image = resizedImage
                cfg.imagePadding = 0
                cfg.imagePlacement = .all
                cfg.baseForegroundColor = btn.isHighlighted
                ? UIColor.label.withAlphaComponent(0.75)
                : UIColor.label
                btn.configuration = cfg
            }
        } else {
            playAndStopButton.setImage(Asset.playButton.image, for: .normal)
            playAndStopButton.setImage(Asset.pauseButton.image, for: .disabled) // on ne l’utilisera pas
        }
    }
    
    func updatePlayButtonUI() {
        let isPlaying = (playState == .playing)
        applyPlayUI(isPlaying: isPlaying)
    }
}
