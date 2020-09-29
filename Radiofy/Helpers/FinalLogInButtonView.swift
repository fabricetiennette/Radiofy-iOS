//
//  FinalLogInButtonView.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 27/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

@IBDesignable
class FinalLogInButtonView: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateStyle()
    }
}

private extension FinalLogInButtonView {
    func updateStyle() {
        layer.cornerRadius = 24
    }
}
