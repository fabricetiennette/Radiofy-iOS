//
//  SubscribeButtonView.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 06/05/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

@IBDesignable
class SubscribeButtonView: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateStyle()
    }
}

private extension SubscribeButtonView {
    func updateStyle() {
        layer.cornerRadius = 24
    }
}
