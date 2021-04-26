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

    private var activityIndicator: NVActivityIndicatorView {
        let midY = self.view.frame.height / 2
        let midX = self.view.frame.width / 2
        let frame = CGRect(x: midX, y: midY, width: 50, height: 50)
        return NVActivityIndicatorView(frame: frame, type: .ballBeat, color: .white, padding: nil)
    }

    @IBAction func subsribeButtonTapped(_ sender: Any) {
        activityIndicator.startAnimating()
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
            me.activityIndicator.stopAnimating()
            me.showAlert(title: title, message: message)
        }
        viewModel.loadingHandler = { [weak self] in
            guard let me = self else { return }
            me.activityIndicator.stopAnimating()
        }
        viewModel.safariServicesHandler = { [weak self] viewController in
            guard let me = self else { return }
            me.present(viewController, animated: true)
        }
        viewModel.successHandler = { [weak self] in
            guard let me = self else { return }
            me.activityIndicator.stopAnimating()
            me.dismiss(animated: true, completion: nil)
        }
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

extension SubscriptionViewController: Storyboarded {}
