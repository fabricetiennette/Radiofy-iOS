//
//  Stack.swift
//  StackAllTheThingsDemo
//
//  Created by Alex Nagy on 19/11/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//

import UIKit

extension UIView {

    fileprivate func stack(_ axis: NSLayoutConstraint.Axis = .vertical, views: [UIView], spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.alignment = alignment
        stackView.distribution = distribution
        addSubview(stackView)
        stackView.edgeTo(self)
        return stackView
    }

    @discardableResult
    open func VStack(_ views: UIView..., spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) -> UIStackView {
        return stack(.vertical, views: views, spacing: spacing, alignment: alignment, distribution: distribution)
    }

    @discardableResult
    open func HStack(_ views: UIView..., spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) -> UIStackView {
        return stack(.horizontal, views: views, spacing: spacing, alignment: alignment, distribution: distribution)
    }

}
