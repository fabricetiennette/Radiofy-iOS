//
//  SearchImageView.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 18/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

@IBDesignable
class SearchImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateStyle()
    }
}

private extension SearchImageView {
    func updateStyle() {
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 1
        layer.shadowRadius = 2
        clipsToBounds = false
    }
}
