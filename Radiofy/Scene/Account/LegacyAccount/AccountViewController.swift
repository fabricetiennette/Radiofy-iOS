//
//  AccountViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 20/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var deleteButton: DeleteAccountView!

//    var viewModel: AccountViewModel!
    private let indicator = LoaderIndicator.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureView()
    }

    @IBAction func deleteAccountTapped(_ sender: Any) {
        showAlertConfirmWithPassword { password in
            self.indicator.show(indicator: self.view)
//            self.viewModel.reauthenticateAndDelete(with: password)
        }
    }
}

private extension AccountViewController {

    func configureViewModel() {
//        viewModel.errorHandler = { [weak self] title, message in
//            guard let me = self else { return }
//            me.indicator.hide()
//            me.showAlert(title: title, message: message)
//        }
//        viewModel.userHandler = { [weak self] username, email in
//            guard let me = self else { return }
//            me.usernameLabel.text = username
//            me.emailLabel.text = email
//        }
//        viewModel.successHandler = { [weak self] in
//            guard let me = self else { return }
//            me.indicator.hide()
//            me.showAlert(title: "Successfully restored", message: "Enjoy Radiofy")
//        }
//        viewModel.userIsNotAnonymous = { [weak self] in
//            guard let me = self else { return }
//            me.deleteButton.isHidden = false
//        }
//        viewModel.isUserAnonymous()
//        viewModel.getUserNameAndEmail()
//        viewModel.isUserLoggedIn()
    }

    func configureView() {
        navigationItem.title = L10n.account
    }
}

extension AccountViewController: Storyboarded {}
