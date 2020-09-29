//
//  CMTime.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 22/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import AVKit

extension CMTime {
    var roundedSeconds: TimeInterval {
        return seconds.rounded()
    }

    func toDisplayString() -> String {
        let rawSeconds = CMTimeGetSeconds(self)
        guard !(rawSeconds.isNaN || rawSeconds.isInfinite) else {
            return "--" // or some other default string
        }
        let hours = Int(rawSeconds.rounded() / 3600 )
        let seconds = Int(rawSeconds.rounded().truncatingRemainder(dividingBy: 60))
        let minutes = Int(rawSeconds.rounded().truncatingRemainder(dividingBy: 3600) / 60)

        return hours > 0 ?
        String(format: "%d:%02d:%02d", hours, minutes, seconds) :
        String(format: "%02d:%02d", minutes, seconds)
    }
}
