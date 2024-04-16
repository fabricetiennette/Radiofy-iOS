//
//  UIViewController+.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 02/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

 // MARK: - Navigation

extension UIViewController {
    func setNavigationBackButton(image: UIImage?, state: UIControl.State) {
        self.navigationItem.backBarButtonItem?.setBackButtonBackgroundImage(image, for: state, barMetrics: .default)
    }

    func setUIBarButtonItem(title: String? = nil, style: UIBarButtonItem.Style, target: Any? = nil, action: Selector? = nil) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: title, style: style, target: target, action: action)
    }
}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    func showAlertAndConfirmLogOut(callback: @escaping () -> Void) {
        let ac = UIAlertController(
            title: L10n.logOut,
            message: L10n.logOutMessage,
            preferredStyle: .alert
        )
        let submitAction = UIAlertAction(title: "OK", style: .destructive) { _ in
            callback()
        }
        ac.addAction(
            UIAlertAction(title: L10n.cancel, style: .cancel, handler: nil)
        )
        ac.addAction(submitAction)
        present(ac, animated: true)
    }

    func showAlertAndGoPremium(
        title: String,
        message: String,
        submitTitle: String,
        cancelTitle: String,
        callback: @escaping () -> Void
    ) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let submitAction = UIAlertAction(title: submitTitle, style: .destructive) { _ in
            callback()
        }
        ac.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
        ac.addAction(submitAction)
        present(ac, animated: true)
    }

    func showAlertConfirmWithPassword(callback: @escaping ((_ password: String?) -> Void)) {
        let ac = UIAlertController(title: L10n.deleteAccount, message: L10n.askPassword, preferredStyle: .alert)
        ac.addTextField()
        ac.textFields![0].isSecureTextEntry = true

        let submitAction = UIAlertAction(title: L10n.deleteAccount, style: .destructive) { [unowned ac] _ in
            let answer = ac.textFields![0]
            callback(answer.text)
        }
        ac.addAction(UIAlertAction(title: L10n.cancelButton, style: .cancel, handler: nil))

        ac.addAction(submitAction)
        present(ac, animated: true)
    }

    func showAlertWithAction(style: UIAlertController.Style, title: String?, message: String?, actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .cancel, handler: nil)], completion: (() -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alert.addAction(action)
            alert.pruneNegativeWidthConstraints()
        }
        present(alert, animated: true)
    }

    func makeCircleWith(size: CGSize, backgroundColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(backgroundColor.cgColor)
        context?.setStrokeColor(UIColor.clear.cgColor)
        let bounds = CGRect(origin: .zero, size: size)
        context?.addEllipse(in: bounds)
        context?.drawPath(using: .fill)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func hexStringToUIColor (hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UIAlertController {
    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}
