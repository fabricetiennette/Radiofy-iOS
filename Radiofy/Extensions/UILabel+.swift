//
//  UILabel+.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 31/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

extension UILabel {
    func slideInFromBottom() {
        let transition1: CATransition = CATransition()
        let timeFunc1: CAMediaTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition1.duration = 0.5
        transition1.timingFunction = timeFunc1
        transition1.type = CATransitionType.push
        transition1.subtype = CATransitionSubtype.fromTop
        self.layer.add(transition1, forKey: kCATransition)
    }

    func slideOut() {
        let transition1: CATransition = CATransition()
        let timeFunc1: CAMediaTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        transition1.duration = 0.5
        transition1.timingFunction = timeFunc1
        transition1.type = CATransitionType.push
        transition1.subtype = CATransitionSubtype.fromBottom
        self.alpha = 0
        self.text = ""
        self.layer.add(transition1, forKey: kCATransition)
    }
}
