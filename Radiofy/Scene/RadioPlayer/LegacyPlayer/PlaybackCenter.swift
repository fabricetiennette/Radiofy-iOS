import AVFoundation
import Combine
import FRadioPlayer

final class PlaybackCenter: NSObject, FRadioPlayerObserver {
    static let shared = PlaybackCenter()
    
    let podPlayer = AVPlayer()
    let radio = FRadioPlayer.shared
    
    @Published private(set) var isRadioPlaying = false
    @Published private(set) var isPodcastPlaying = false
    
    private var podObs: NSKeyValueObservation?
    
    private override init() {
        super.init()
        
        radio.addObserver(self)
        
        // PlaybackCenter.swift
        podObs = podPlayer.observe(\.timeControlStatus, options: [.new]) { [weak self] player, _ in
            guard let self else { return }
            switch player.timeControlStatus {
            case .playing:
                if self.isPodcastPlaying == false { self.isPodcastPlaying = true }
            case .paused:
                if self.isPodcastPlaying == true { self.isPodcastPlaying = false }
            case .waitingToPlayAtSpecifiedRate:
                break
            @unknown default:
                break
            }
        }
    }
    
    deinit {
        podObs = nil
        radio.removeObserver(self)
    }
    
    // MARK: - Contrôles de lecture
    
    // Radio
    func playRadio() { radio.play() }
    func stopRadio() { radio.stop() } // stop (ou pause si tu préfères)
    
    // Podcast
    func playPodcast() {
        if isPodcastPlaying == false { isPodcastPlaying = true }   // optimiste
        podPlayer.play()
    }
    
    func pausePodcast() {
        if isPodcastPlaying == true { isPodcastPlaying = false }   // optimiste
        podPlayer.pause()
    }
    
    // MARK: - FRadioPlayerObserver
    func radioPlayer(_ player: FRadioPlayer, playbackStateDidChange state: FRadioPlayer.PlaybackState) {
        isRadioPlaying = (state == .playing)
    }
    
    // (Facultatif) utile si tu veux réagir à loading/buffering plus tard
    func radioPlayer(_ player: FRadioPlayer, playerStateDidChange state: FRadioPlayer.State) { /* no-op */ }
}
