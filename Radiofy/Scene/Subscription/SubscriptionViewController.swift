//
//  SubscriptionViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 06/05/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SubscriptionViewController: UIViewController {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!

    var viewModel: SubscriptionViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureCGU()
    }

    @IBAction func subsribeButtonTapped(_ sender: Any) {
        startAnimation()
    }

    @IBAction func skipButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func termOfServiceButtonTapped(_ sender: Any) {
        viewModel.showSafariView(with: .termOfService)
    }

    @IBAction func privacyPolicyButtonTapped(_ sender: Any) {
        viewModel.showSafariView(with: .privacy)
    }
}

private extension SubscriptionViewController {

    func configureViewModel() {
        viewModel.errorHandler = { [weak self] title, message in
            guard let me = self else { return }
            me.stopAnimating()
            me.showAlert(title: title, message: message)
        }
        viewModel.loadingHandler = { [weak self] in
            guard let me = self else { return }
            me.stopAnimating()
        }
        viewModel.safariServicesHandler = { [weak self] viewController in
            guard let me = self else { return }
            me.present(viewController, animated: true)
        }
        viewModel.successHandler = { [weak self] in
            guard let me = self else { return }
            me.stopAnimating()
            me.dismiss(animated: true, completion: nil)
        }
    }

    func startAnimation() {
        let size = CGSize(width: 50, height: 50)
        startAnimating(size, type: .ballBeat, color: .white, fadeInAnimation: nil)
    }

    func configureCGU() {
        let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 12),
        .foregroundColor: UIColor.white,
        .underlineStyle: NSUnderlineStyle.single.rawValue]

        let termsString = NSMutableAttributedString(
            string: L1s.terms, attributes: attributes)
        let  privacyString = NSMutableAttributedString(
            string: L1s.privacyPolicy, attributes: attributes)
        termsButton.setAttributedTitle(termsString, for: .normal)
        privacyButton.setAttributedTitle(privacyString, for: .normal)
    }
}

extension SubscriptionViewController: Storyboarded, NVActivityIndicatorViewable {}
