//
//  SignMeUpButtonView.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 27/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

@IBDesignable
class SignMeUpButtonView: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateStyle()
    }
}

private extension SignMeUpButtonView {
    func updateStyle() {
        layer.cornerRadius = 24
    }
}
