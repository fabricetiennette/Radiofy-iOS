//swiftlint:disable function_body_length
//
//  UIButton+.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 30/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import Lottie

extension UIButton {
    func animateWhileAwaitingResponse(showLoading: Bool, originalConstraints: [NSLayoutConstraint], identifier: String, title: String) {

        let animationView = AnimationView()
        animationView.animation = Animation.named("loader1010")
        animationView.isUserInteractionEnabled = false
        self.isUserInteractionEnabled = false

        // Constraints which will add in supper view
        let constraints = [
            NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: self.superview, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: animationView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: animationView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: animationView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 50),
            NSLayoutConstraint(item: animationView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 50)
        ]

        // Constrains which will add in button
        let selfCostraints = [
            NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 50),
            NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 50)
        ]

        // Keeping this outside of condition due to adding constrains programatically.
        self.translatesAutoresizingMaskIntoConstraints = false
        animationView.translatesAutoresizingMaskIntoConstraints = false

        if showLoading {
            // Remove width constrains of button from superview
            // Identifier given in storyboard constrains
            self.superview?.constraints.forEach({ (constraint) in
                if constraint.identifier == identifier {
                    constraint.isActive = false
                }
            })

            NSLayoutConstraint.deactivate(self.constraints)

            animationView.contentMode = .scaleAspectFill
            animationView.loopMode = .loop
            self.setTitle("", for: .normal)
            self.addSubview(animationView)
            self.superview?.addConstraints(constraints)
            self.addConstraints(selfCostraints)
            animationView.play()
            animationView.alpha = 0

            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveLinear, animations: {
                self.setTitleColor(.clear, for: .normal)
                self.layer.cornerRadius = self.frame.height / 2
                animationView.alpha = 1
                self.layoutIfNeeded()
            }, completion: nil)

        } else {

            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveLinear, animations: {

                for subview in self.subviews where subview is AnimationView {
                    subview.removeFromSuperview()
                }

                self.removeConstraints(selfCostraints)
                NSLayoutConstraint.deactivate(self.constraints)
                self.superview?.addConstraints(originalConstraints)
                NSLayoutConstraint.activate(originalConstraints)
                self.setTitle(title, for: .normal)
                self.setTitleColor(.black, for: .normal)
                self.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
                self.layer.cornerRadius = 24
                self.layoutIfNeeded()
            }, completion: nil)
            self.isUserInteractionEnabled = true
        }
    }
}
