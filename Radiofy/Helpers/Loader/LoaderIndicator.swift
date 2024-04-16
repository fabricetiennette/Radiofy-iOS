//
//  LoaderIndicator.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 26/04/2021.
//  Copyright © 2021 Fabrice Etiennette. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoaderIndicator: UIView {

    public static let shared = LoaderIndicator()

    private var indicator: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80), type: .ballBeat, color: .white)
        indicator.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    func show(indicator forView: UIView) {
        indicator.startAnimating()

        forView.addSubview(indicator)
        indicator.layer.cornerRadius = 8
        NSLayoutConstraint.activate([
            indicator.centerYAnchor.constraint(equalTo: forView.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: forView.centerXAnchor),
            indicator.widthAnchor.constraint(equalToConstant: 150),
            indicator.heightAnchor.constraint(equalToConstant: 100)
        ])
        indicator.bringSubviewToFront(forView)
    }

    func hide() {
        indicator.stopAnimating()
        indicator.removeFromSuperview()
    }
}
