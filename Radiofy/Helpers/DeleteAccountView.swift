//
//  DeleteAccountView.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 20/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

@IBDesignable
class DeleteAccountView: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateStyle()
    }
}

private extension DeleteAccountView {
    func updateStyle() {
        layer.cornerRadius = 24
    }
}
