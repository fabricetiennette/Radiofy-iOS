//
//  SubcribePremiumView.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 06/05/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

@IBDesignable
class SubcribePremiumView: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateStyle()
    }
}

private extension SubcribePremiumView {
    func updateStyle() {
        layer.cornerRadius = 10
    }
}

@IBDesignable
class SubcribePremiumInside: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateStyle()
    }
}

private extension SubcribePremiumInside {
    func updateStyle() {
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
    }
}

@IBDesignable
class SubcribePremiumRight: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateStyle()
    }
}

private extension SubcribePremiumRight {
    func updateStyle() {
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
}
