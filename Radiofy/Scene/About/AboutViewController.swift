//
//  AboutViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 20/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AboutViewController: UIViewController {

    @IBOutlet private weak var bannerView: GADBannerView!

    var viewModel: AboutViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureView()
        configureAdMob()
    }

    @IBAction private func thirdPartySoftwareTapped(_ sender: Any) {
        viewModel.showSafariView(with: .thirdPartySoftware)
    }

    @IBAction private func showPrivacyPolicyTap(_ sender: Any) {
        viewModel.showSafariView(with: .privacy)
    }
}

private extension AboutViewController {

    func configureViewModel() {
        viewModel.errorHandler = { [weak self] title, message in
            guard let me = self else { return }
            me.showAlert(title: title, message: message)
        }
        viewModel.safariServicesHandler = { [weak self] viewController in
            guard let me = self else { return }
            me.present(viewController, animated: true)
        }
    }

    func configureView() {
        navigationItem.title = L1s.about
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

extension AboutViewController: Storyboarded {}
