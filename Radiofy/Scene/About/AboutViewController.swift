//
//  AboutViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 20/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    var viewModel: AboutViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureView()
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
}

extension AboutViewController: Storyboarded {}
