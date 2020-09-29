//
//  StartViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 23/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    var viewModel: StartViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadViewIfNeeded()
    }

    @IBAction private func signUpButtonTapped(_ sender: Any) {
        viewModel.openSignUpView()
    }

    @IBAction private func logInButtonTapped(_ sender: Any) {
        viewModel.openLogInView()
    }

    @IBAction func skipRegistration(_ sender: Any) {
        viewModel.signInAnonymously()
    }
}

private extension StartViewController {
    func configureViewModel() {
        viewModel.errorHandler = { [weak self] title, message in
            guard let me = self else { return }
            me.showAlert(title: title, message: message)
        }
    }
}

extension StartViewController: Storyboarded {}
