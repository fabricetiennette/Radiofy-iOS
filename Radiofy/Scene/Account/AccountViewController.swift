//
//  AccountViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 20/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import GoogleMobileAds

class AccountViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var deleteButton: DeleteAccountView!
    @IBOutlet private weak var bannerView: GADBannerView!

    var viewModel: AccountViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureView()
        configureAdMob()
    }

    @IBAction func restorePurchases(_ sender: Any) {
        startAnimation()
        viewModel.restorePurchase()
    }

    @IBAction func showPremiumOffer(_ sender: Any) {
        viewModel.openSubscriptionPage()
    }

    @IBAction func deleteAccountTapped(_ sender: Any) {
        showAlertConfirmWithPassword { password in
            self.startAnimation()
            self.viewModel.reauthenticateAndDelete(with: password)
        }
    }
}

private extension AccountViewController {

    func configureViewModel() {
        viewModel.errorHandler = { [weak self] title, message in
            guard let me = self else { return }
            me.stopAnimating()
            me.showAlert(title: title, message: message)
        }
        viewModel.userHandler = { [weak self] username, email in
            guard let me = self else { return }
            me.usernameLabel.text = username
            me.emailLabel.text = email
        }
        viewModel.successHandler = { [weak self] in
            guard let me = self else { return }
            me.stopAnimating()
            me.showAlert(title: "Successfully restored", message: "Enjoy Radiofy")
        }
        viewModel.userIsNotAnonymous = { [weak self] in
            guard let me = self else { return }
            me.deleteButton.isHidden = false
        }
        viewModel.isUserAnonymous()
        viewModel.getUserNameAndEmail()
        viewModel.isUserLoggedIn()
    }

    func startAnimation() {
        let size = CGSize(width: 50, height: 50)
        startAnimating(size, type: .ballBeat, color: .white, fadeInAnimation: nil)
    }

    func configureView() {
        navigationItem.title = L1s.compte
    }

    func configureAdMob() {
        bannerView.isHidden = true
        if HomeViewController.isUserPremium == false {
            bannerView.isHidden = false
            bannerView.adUnitID = "ca-app-pub-2776074318440444/3415741188"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
    }
}

extension AccountViewController: Storyboarded, NVActivityIndicatorViewable {}
