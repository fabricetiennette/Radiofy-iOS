//
//  ForgettenPasswordButtonView.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 27/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

@IBDesignable
class ForgettenPasswordButtonView: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateStyle()
    }
}

private extension ForgettenPasswordButtonView {
    func updateStyle() {
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightText.cgColor
    }
}
