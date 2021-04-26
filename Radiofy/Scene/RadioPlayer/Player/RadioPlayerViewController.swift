// swiftlint:disable block_based_kvo file_length
//
//  RadioPlayerViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 10/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import LNPopupController
import MediaPlayer
import FRadioPlayer
import AVKit
import NVActivityIndicatorView

class RadioPlayerViewController: UIViewController {

    @IBOutlet weak var magicView: UIView!
    @IBOutlet weak var radioTopLabel: UILabel!
    @IBOutlet weak var radioImageView: UIImageView!
    @IBOutlet weak var radioMainLabel: UILabel!
    @IBOutlet weak var liveLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playerSlider: UISlider!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!

    var viewModel: RadioPlayerViewModel!

    private let radioPlayer = FRadioPlayer.shared
    private let podPlayer = AVPlayer()
    private var playerItem: AVPlayerItem?
    private var isRadio: Bool?
    static var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        RadioPlayerViewController.player = podPlayer
        radioPlayer.delegate = self
        setupAudioSession()
        observePlayerCurrentTime()
        setupRemoteTransportControls()
        configureViewModel()
        addObserver()
        setSliderThumbTintColor(.white)
    }
}

extension RadioPlayerViewController {

    @objc private func playStation(notification: Notification) {
        viewModel.playFromProfile { isNotPlaying in
            isRadio = true
            if isNotPlaying || radioPlayer.playbackState == .stopped {
                castRadio()
            }
        }
    }

    @objc private func playEpisode(notification: Notification) {
        viewModel.playPodcastEpisode { isNotPlaying in
            isRadio = false
            if isNotPlaying || podPlayer.timeControlStatus == .paused {
                castPodcast()
            }
        }
    }

    @IBAction func handleCurrentTimeSliderChange(_ sender: Any) {
      let percentage = playerSlider.value
      guard let duration = podPlayer.currentItem?.duration else { return }
      let durationInSeconds = CMTimeGetSeconds(duration)
      let seekTimeInSeconds = Float64(percentage) * durationInSeconds
      let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
      MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeInSeconds
      podPlayer.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero)
    }

    @IBAction func handleFastForward(_ sender: Any) {
      seekToCurrentTime(delta: 10)
    }

    @IBAction func handleRewind(_ sender: Any) {
      seekToCurrentTime(delta: -10)
    }

    @IBAction func dismissTapped(_ sender: Any) {
        viewModel.closeRadioPlayer()
    }

    @IBAction func playButtonTapped(_ sender: Any) {
        playOrPause()
    }
}

extension RadioPlayerViewController: FRadioPlayerDelegate {

    func radioPlayer(_ player: FRadioPlayer, playbackStateDidChange state: FRadioPlaybackState) {
        switch player.playbackState {
        case .playing:
            playButton.isSelected = true
            playerSlider.value = 0
            playerSlider.isEnabled = false
            liveLabel.isHidden = false
            currentTimeLabel.isHidden = true
            durationLabel.isHidden = true
            replayButton.isEnabled = false
            forwardButton.isEnabled = false
            liveLabel.textColor = UIColor(cgColor: #colorLiteral(red: 0.1137254902, green: 0.7254901961, blue: 0.3294117647, alpha: 1))
            popupItem.progress = 1.0
            setRadioBackgroundColor()
            popupItem.subtitle = L1s.live
        case .stopped:
            liveLabel.isHidden = false
            currentTimeLabel.isHidden = true
            durationLabel.isHidden = true
            playButton.isSelected = false
            liveLabel.textColor = .lightGray
            popupItem.progress = 0.0
            popupItem.subtitle = "..."
        default: break
        }
    }

    func radioPlayer(_ player: FRadioPlayer, playerStateDidChange state: FRadioPlayerState) {
        switch player.state {
        case .error:
            popupItem.subtitle = L1s.unavailableRadioPlay
        case .loading:
            popupItem.subtitle = L1s.loadingTitle
        case .loadingFinished:
            popupItem.subtitle = L1s.live
        case .readyToPlay:
            popupItem.subtitle = L1s.ready
        default: break
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if object as AnyObject? === podPlayer {
            if keyPath == "timeControlStatus" {
                if podPlayer.timeControlStatus == .playing {
                    stopAnimation()
                    playerSlider.isEnabled = true
                    playButton.isSelected = true
                    durationLabel.isHidden = false
                    currentTimeLabel.isHidden = false
                    replayButton.isEnabled = true
                    forwardButton.isEnabled = true
                    liveLabel.isHidden = true
                    popupItem.progress = 1.0
                    setBackgroundColor()
                    popupItem.subtitle = "Podcast"
                } else if podPlayer.timeControlStatus == .paused {
                    stopAnimation()
                    playButton.isSelected = false
                    popupItem.progress = 0.0
                    popupItem.subtitle = "..."
                } else if podPlayer.timeControlStatus == .waitingToPlayAtSpecifiedRate {
                    startAnimation()
                    popupItem.subtitle = L1s.loadingTitle
                }
            }
        }
    }
}

private extension RadioPlayerViewController {

    func startAnimation() {
        durationLabel.isHidden = true
        currentTimeLabel.isHidden = true
        liveLabel.isHidden = true
        activityIndicator.startAnimating()
    }

    func stopAnimation() {
        activityIndicator.stopAnimating()
    }

    func setRadioBackgroundColor() {
         magicView.viewWithTag(1212)?.removeFromSuperview()
        guard let mainColor = viewModel.audio.first?.mainColor else { return }
        magicView.backgroundColor = mainColor
        if #available(iOS 13.0, *) {
            magicView.addBlurEffect(alpha: 1, style: .systemThinMaterialDark)
        } else {
            // Fallback on earlier versions
            magicView.addBlurEffect(alpha: 1, style: .dark)
        }
    }

    func setBackgroundColor() {
        magicView.viewWithTag(1212)?.removeFromSuperview()
        guard let color = radioImageView.image?.averageColor else { return }
        magicView.backgroundColor = color
        if #available(iOS 13.0, *) {
            magicView.addBlurEffect(alpha: 1, style: .systemThinMaterialDark)
        } else {
            // Fallback on earlier versions
            magicView.addBlurEffect(alpha: 1, style: .dark)
        }
    }

    func setSliderThumbTintColor(_ color: UIColor) {
        let circleImage = makeCircleWith(size: CGSize(width: 15, height: 15),
                       backgroundColor: color)
        playerSlider.setThumbImage(circleImage, for: .normal)
        playerSlider.setThumbImage(circleImage, for: .highlighted)
    }

    func setupAudioSession() {
      do {
        try AVAudioSession.sharedInstance().setCategory(
            AVAudioSession.Category.playback, mode: .default)
        try AVAudioSession.sharedInstance().setActive(true)
      } catch let sessionErr {
        print("Failed to activate session:", sessionErr)
      }
    }

    func seekToCurrentTime(delta: Int64) {
      let tenSeconds = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(podPlayer.currentTime(), tenSeconds)
        podPlayer.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero)
    }

    func observePlayerCurrentTime() {
      let interval = CMTimeMake(value: 1, timescale: 2)
      podPlayer.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
        guard let me = self else { return }
        guard let durationTime = me.podPlayer.currentItem?.duration else { return }
        me.currentTimeLabel.text = time.toDisplayString()
        me.durationLabel.text = "-\(durationTime.toDisplayString())"
        me.updateCurrentTimeSlider()
        me.setupLockscreenDuration()
      }
    }

    func updateCurrentTimeSlider() {
      let currentTimeSeconds = CMTimeGetSeconds(podPlayer.currentTime())
      let durationSeconds = CMTimeGetSeconds(podPlayer.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
      let percentage = currentTimeSeconds / durationSeconds
      playerSlider.value = Float(percentage)
    }
}

private extension RadioPlayerViewController {

    func castRadio() {
        if viewModel.audio.isEmpty {
            return
        } else if podPlayer.rate != 0 && podPlayer.error == nil {
            podPlayer.pause()
            radioPlayer.play()
        } else {
            radioPlayer.play()
        }
    }

    func castPodcast() {
        if viewModel.audio.isEmpty {
            return
        } else if radioPlayer.isPlaying {
            radioPlayer.stop()
            podPlayer.play()
        } else {
             podPlayer.play()
        }
    }

    func playOrPause() {
        if viewModel.audio.isEmpty {
            return
        } else if isRadio == true {
            playOrStopRadio()
        } else {
            podPlayOrPause()
        }
    }

    func playOrStopRadio() {
        if radioPlayer.isPlaying {
            radioPlayer.stop()
        } else {
            radioPlayer.play()
        }
    }

    func podPlayOrPause() {
        if podPlayer.rate != 0 && podPlayer.error == nil {
            podPlayer.pause()
        } else {
            podPlayer.play()
        }
    }
}

private extension RadioPlayerViewController {

    func configureViewModel() {
        viewModel.audioHandle = { [weak self] audio in
            guard let me = self else { return }
            guard let audio = audio.first,
                let imageUrl = URL(string: audio.imageURL),
                let streamUrl = URL(string: audio.streamURL)
                else { return }
            DispatchQueue.main.async {
                me.getRadioOrPodcastURL(streamUrl: streamUrl, audio: audio)
                me.radioImageView.sd_setImage(with: imageUrl) { (image, _, _, _) in
                    me.popupItem.image = image
                }
                me.radioMainLabel.text = audio.name
                me.popupItem.title = audio.name
                me.updateNowPlaying(with: audio)
            }
        }
    }

    func getRadioOrPodcastURL(streamUrl: URL, audio: AudioItem) {
        if isRadio == true {
            radioPlayer.radioURL = streamUrl
            radioTopLabel.text = audio.name
        } else {
            playerItem = AVPlayerItem(url: streamUrl)
            podPlayer.replaceCurrentItem(with: playerItem)
            radioTopLabel.text = audio.author
        }
    }

    func addObserver() {
        podPlayer.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(playStation(notification:)),
            name: RadioViewModel.NotificationPlayPressed, object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(playEpisode(notification:)),
            name: EpisodeViewModel.NotificationEpisode, object: nil
        )
    }
}

private extension RadioPlayerViewController {

    func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] _ in
            if self.isRadio == true {
            self.radioPlayer.play()
            } else {
                self.podPlayer.play()
                self.setupElapsedTime(playbackRate: 1)
            }
            return .success
        }

        // middle button (toggle/pause) is clicked
        commandCenter.togglePlayPauseCommand.addTarget { [unowned self] _ in
            if self.viewModel.audio.isEmpty {
                return .commandFailed
            } else if self.isRadio == true {
                if self.radioPlayer.isPlaying {
                    self.radioPlayer.stop()
                    self.setupElapsedTime(playbackRate: 0)
                } else {
                    self.radioPlayer.play()
                    self.setupElapsedTime(playbackRate: 1)
                }
            } else {
                if self.podPlayer.rate != 0 && self.podPlayer.error == nil {
                    self.podPlayer.pause()
                    self.setupElapsedTime(playbackRate: 0)
                } else {
                    self.podPlayer.play()
                    self.setupElapsedTime(playbackRate: 1)
                }
            }
         return .success
        }

        // Add handler for Stop Command
        commandCenter.pauseCommand.addTarget { [unowned self] _ in
            if self.isRadio == true {
                self.radioPlayer.stop()
            } else {
                self.podPlayer.pause()
                self.setupElapsedTime(playbackRate: 0)
            }
            return .success
        }
    }

    func setupElapsedTime(playbackRate: Float) {
      let elapsedTime = CMTimeGetSeconds(podPlayer.currentTime())
      MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
      MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = playbackRate
    }

    func setupLockscreenDuration() {
      guard let duration = podPlayer.currentItem?.duration else { return }
      let durationSeconds = CMTimeGetSeconds(duration)
      MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationSeconds
    }

    func updateNowPlaying(with audio: AudioItem?) {
        var nowPlayingInfo = [String: Any]()
        if let image = radioImageView.image {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { _ -> UIImage in
                return image
            })
        }
        if isRadio == true {
            nowPlayingInfo[MPMediaItemPropertyArtist] = L1s.liveTitle
            nowPlayingInfo[MPMediaItemPropertyTitle] = audio?.name
            nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = true
        } else {
            nowPlayingInfo[MPMediaItemPropertyArtist] = "Podcast"
            nowPlayingInfo[MPMediaItemPropertyTitle] = audio?.name
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}

extension RadioPlayerViewController: Storyboarded {}

extension RadioPlayerViewController: MusicPlayerDelegate {

    func play() {
        if isRadio == true {
            radioPlayer.play()
        } else {
            podPlayer.play()
        }
    }

    func stop() {
        if isRadio == true {
            self.radioPlayer.stop()
        } else {
            podPlayer.pause()
        }
    }
}

extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}
