//
//  UIView+.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 03/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

extension UIView {

    func setBackgourndColorWithGradient(colorHead: UIColor, colorCenter: UIColor, colorBottom: UIColor) {

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.frame
        gradientLayer.colors = [colorHead.cgColor, colorCenter.cgColor, colorBottom.cgColor]
        gradientLayer.locations = [0.0, 0.6, 1.0]

        self.layer.addSublayer(gradientLayer)
    }

    func addBlurEffect(alpha: CGFloat, style: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: style)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = self.bounds
        blurredEffectView.alpha = alpha
        blurredEffectView.tag = 1212
        self.addSubview(blurredEffectView)
    }
}
