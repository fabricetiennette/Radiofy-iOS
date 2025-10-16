//
//  MiniPlayerViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 11/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation

enum AudioType {
    case radio
    case podcast
}

protocol MusicPlayerDelegate: AnyObject {
    var audioType: AudioType { get set }
    var isAudioPlaying: Bool { get}
    
    func play()
    func stop()
}

struct MiniPlayerViewModel {

    private weak var view: MusicPlayerDelegate?
    
    var audioType: AudioType {
        get { view?.audioType ?? .radio }
        set { view?.audioType = newValue }
    }
    
    var isAudioPlaying: Bool {
        get { view?.isAudioPlaying ?? false }
    }

    init(view: MusicPlayerDelegate) {
        self.view = view
    }

    func play() {
        view?.play()
    }

    func stop() {
        view?.stop()
    }
}
