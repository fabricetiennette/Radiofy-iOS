//
//  MorningHomeCellView.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 08/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

@IBDesignable
class MorningHomeCellView: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateStyle()
    }
}

private extension MorningHomeCellView {
    func updateStyle() {
        layer.cornerRadius = 5
    }
}

@IBDesignable
class MorningHomeCellImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateStyle()
    }
}

private extension MorningHomeCellImageView {
    func updateStyle() {
        layer.cornerRadius = 5
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
    }
}
