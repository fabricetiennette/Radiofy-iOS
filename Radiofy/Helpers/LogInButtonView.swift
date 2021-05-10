//
//  LogInButtonView.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 27/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//
import UIKit

#warning("TODO: Check and Remove")
@IBDesignable
class LogInButtonView: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateStyle()
    }
}

private extension LogInButtonView {
    func updateStyle() {
        layer.cornerRadius = 24
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightText.cgColor
    }
}
