//
//  ButtonRadioView.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 12/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

@IBDesignable
class ButtonRadioView: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateStyle()
    }
}

private extension ButtonRadioView {
    func updateStyle() {
        layer.cornerRadius = 24
    }
}
