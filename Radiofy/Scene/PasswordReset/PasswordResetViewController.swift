//
//  PasswordResetViewController.swift
//  Radiofy
//
//  Created by Fabrice Etiennette on 29/03/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import UIKit
import Combine

class PasswordResetViewController: UIViewController, Storyboarded {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var errorTextLabel: UILabel!
    @IBOutlet private weak var resetEmailButton: FinalLogInButtonView!

    private var disposeBag: Set<AnyCancellable> = []
    var viewModel: PasswordResetModule.ViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupBindings()
    }

    @objc private func tapView() {
        viewEndEditing()
    }

    @objc private func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        errorTextLabel.slideOut()
        guard let email = emailTextField.text, !email.isEmpty else {
            resetEmailButton.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.3018799424, green: 0.3020585179, blue: 0.2976047993, alpha: 1))
            resetEmailButton.isEnabled = false
            return
        }
        resetEmailButton.backgroundColor = .white
        resetEmailButton.isEnabled = true
    }

    @IBAction private func resetEmailButtonTapped(_ sender: Any) {
        viewEndEditing()

        guard let viewModel = self.viewModel else { return }
        let email = emailTextField.text

        viewModel.resetPassword(with: email)
    }

    @IBAction private func emailTextFieldTapped(_ sender: Any) {
        emailTextField.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.4382694662, green: 0.443403244, blue: 0.4388435185, alpha: 1))
    }
}

private extension PasswordResetViewController {

    func setupBindings() {
        guard let viewModel = self.viewModel else { return }

        viewModel
            .errorPublisher
            .sink(receiveValue: { [weak self] message in
                guard let me = self else { return }
                if me.errorTextLabel.text != message {
                    me.errorTextLabel.slideInFromBottom()
                }
                me.errorTextLabel.text = message
                me.errorTextLabel.alpha = 1
            })
            .store(in: &disposeBag)

        viewModel
            .emailSuccessPublisher
            .sink(receiveValue: { [weak self] message in
                guard let me = self else { return }
                me.errorTextLabel.text = message
                me.errorTextLabel.textColor = .green
                me.errorTextLabel.alpha = 1
            })
            .store(in: &disposeBag)
    }

    func configureView() {
        errorTextLabel.alpha = 0
        emailTextField.becomeFirstResponder()
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(tapView)))
        configureLogInButton()
    }

    func configureLogInButton() {
         resetEmailButton.isEnabled = false
        [emailTextField].forEach { $0?.addTarget(self, action: #selector(editingChanged), for: .editingChanged)}
    }

    func viewEndEditing() {
        view.endEditing(true)
        emailTextField.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.2548763454, green: 0.2549183369, blue: 0.2548671067, alpha: 1))
    }
}
