//
//  MiniPlayerViewModel.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 11/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import Foundation

protocol MusicPlayerDelegate: AnyObject {
    func play()
    func stop()
}

struct MiniPlayerViewModel {

    unowned private let view: MusicPlayerDelegate

    init(view: MusicPlayerDelegate) {
        self.view = view
    }

    func play() {
        view.play()
    }

    func stop() {
        view.stop()
    }
}
