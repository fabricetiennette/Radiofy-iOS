//
//  RadioPlayerViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 10/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

protocol RadioPlayerViewModelDelegate: AnyObject {
    func closeAudioPlayer()
}

class RadioPlayerViewModel {

    private weak var delegate: RadioPlayerViewModelDelegate?

    var audioHandle: ((_ selectedAudio: [AudioItem]) -> Void)?
    var audio: [AudioItem] = []

    init(delegate: RadioPlayerViewModelDelegate?) {
        self.delegate = delegate
    }

    func closeRadioPlayer() {
        delegate?.closeAudioPlayer()
    }

    func playFromProfile(callback: ((Bool) -> Void)) {
//        guard let radioStaion = RadioViewModel.radioStation else { return }
//
//        let audioRadio = AudioItem(
//            name: radioStaion.name,
//            streamURL: radioStaion.streamURL,
//            imageURL: radioStaion.imageURL,
//            author: "",
//            mainColor: radioStaion.color
//        )
//
//        if audio.first?.name == radioStaion.name {
//            callback(false)
//        } else {
//            audio.removeAll()
//            audio.append(audioRadio)
//            saveRecenltyPlayedStationToUserDefaults()
//            audioHandle?(audio)
//            callback(true)
//        }
    }

    func playPodcastEpisode(callback: ((Bool) -> Void)) {
        guard let podcastEpisode = EpisodeViewModel.episode.first,
            let imageURL = podcastEpisode.imageUrl else { return }

        let audioPodcast = AudioItem(
            name: podcastEpisode.title,
            streamURL: podcastEpisode.streamUrl,
            imageURL: imageURL,
            author: podcastEpisode.author,
            mainColor: nil
        )
        if audio.first?.name == podcastEpisode.title {
            callback(false)
        } else {
            audio.removeAll()
            audio.append(audioPodcast)
            audioHandle?(audio)
            callback(true)
        }
    }

    // Save recently played station to user defaults. Keep a list of 5 unique station
    private func saveRecenltyPlayedStationToUserDefaults() {
        var oldPlayerList = UserDefaultConfig.recentlyPlayed
        if oldPlayerList.count > 4 {
            oldPlayerList.removeLast()
        }
        if let newElement = audio.first?.name {
            oldPlayerList.insert(newElement, at: 0)
            let radioName = oldPlayerList.unique()
            UserDefaultConfig.recentlyPlayed = radioName
        }
    }
}

struct AudioItem {
    var name: String
    var streamURL: String
    var imageURL: String
    var author: String
    var mainColor: UIColor?
}
