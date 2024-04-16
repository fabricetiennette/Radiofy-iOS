//
//  UIStackView+.swift
//  StackAllTheThingsDemo
//
//  Created by Alex Nagy on 19/11/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import UIKit

public enum Padding {
    case top, left, right, bottom, verticalMargins, horizontalMargins, allMargins
}

extension UIStackView {

    @discardableResult
    open func setupSubview(backgroundColor: UIColor = .white, cornerRadius: CGFloat = 0, borderWidth: CGFloat = 0, borderColor: UIColor = .clear) -> UIStackView {
        let subview = UIView(frame: bounds)
        subview.backgroundColor = backgroundColor
        subview.layer.masksToBounds = true
        subview.layer.cornerRadius = cornerRadius
        subview.layer.borderWidth = borderWidth
        subview.layer.borderColor = borderColor.cgColor
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subview, at: 0)
        return self
    }

    @discardableResult
    open func height(_ height: CGFloat) -> UIStackView {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }

    @discardableResult
    open func heightGreater(_ height: CGFloat) -> UIStackView {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
        return self
    }

    @discardableResult
    open func width(_ width: CGFloat) -> UIStackView {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        return self
    }

    @discardableResult
    open func padding(_ margins: [Padding], amount: CGFloat) -> UIStackView {
        isLayoutMarginsRelativeArrangement = true

        margins.forEach { (padding) in
            switch padding {
            case .top:
                layoutMargins.top = amount
            case .left:
                layoutMargins.left = amount
            case .right:
                layoutMargins.right = amount
            case .bottom:
                layoutMargins.bottom = amount
            case .verticalMargins:
                layoutMargins.top = amount
                layoutMargins.bottom = amount
            case .horizontalMargins:
                layoutMargins.left = amount
                layoutMargins.right = amount
            case .allMargins:
                layoutMargins = UIEdgeInsets(top: amount, left: amount, bottom: amount, right: amount)
            }
        }
        return self
    }
}
