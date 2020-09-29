//
//  LaunchScreenManager.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 25/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class LaunchScreenManager {

    // MARK: - Properties

    static let instance = LaunchScreenManager(animationDurationBase: 1.5)

    private let animationDurationBase: Double

    // MARK: - Lifecycle

      init(animationDurationBase: Double) {
          self.animationDurationBase = animationDurationBase
      }

    // MARK: - Animation

    func animateAfterLaunch(_ parentViewPassedIn: UIView?) {
        let view = loadView()

        fillParentViewWithView(parentViewPassedIn, view)

        slideInLogoFromTop(in: view)
    }

    private func loadView() -> UIView {
        // swiftlint:disable:next force_cast
        return UINib(nibName: "LaunchScreen", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }

    private func fillParentViewWithView(_ parentView: UIView?, _ nibView: UIView) {
        parentView?.addSubview(nibView)

        if let view = parentView {
            nibView.frame = view.bounds
            nibView.center = view.center
        }
    }

    private func slideInLogoFromTop(in nibView: UIView) {
        let radiofyLogo = nibView.viewWithTag(1)
        let transition = CATransition()
        let timmingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        transition.duration = 1.5
        transition.timingFunction = timmingFunction
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        radiofyLogo?.layer.add(transition, forKey: kCATransition)

        DispatchQueue.main.asyncAfter(
            deadline: .now() + animationDurationBase * 1.4
        ) {
            nibView.removeFromSuperview()
        }
    }
}
